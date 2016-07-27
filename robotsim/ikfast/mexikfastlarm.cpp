#include "mex.h" 
#include <vector>
using namespace std;

#include "ikfast.h"

bool checkArmLimit(vector<IkReal> sol) {
    double pi = 3.1415926;
    double safemargin = 5;
    double lftrng[12];
    lftrng[0] = -(88-safemargin)*pi/180;
    lftrng[1] = +(88-safemargin)*pi/180;
    lftrng[2] = -(140-safemargin)*pi/180;
    lftrng[3] = +(60-safemargin)*pi/180;
    lftrng[4] = -(158-safemargin)*pi/180;
    lftrng[5] = +(0-safemargin)*pi/180;
    lftrng[6] = -(105-safemargin)*pi/180;
    lftrng[7] = +(165-safemargin)*pi/180;
    lftrng[8] = -(100-safemargin)*pi/180;
    lftrng[9] = +(100-safemargin)*pi/180;
    lftrng[10] = -(163-safemargin)*pi/180;
    lftrng[11] = +(163-safemargin)*pi/180;
    
    for(int i = 0; i<6; i++)
    {
        if(sol[i]<lftrng[2*i] || sol[i]>lftrng[2*i+1]) {
            return false;
        }
    }
    
    return true;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs,const mxArray *prhs[])
{
    double *jnts;
    double *isdone;
    
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    plhs[1] = mxCreateDoubleMatrix(6, 1, mxREAL); 
    isdone = mxGetPr(plhs[0]);
    jnts = mxGetPr(plhs[1]);
    
    double *pos;
    double *rot;
    pos = mxGetPr(prhs[0]);
    rot = mxGetPr(prhs[1]);
    
    IkReal eetrans[3];
    IkReal eerot[9];
    for(int i=0; i<3; i++) {
        eetrans[i] = pos[i];
        for(int j=0; j<3; j++) {
            eerot[3*i+j] = rot[3*i+j];
        }
    }
    
    ikfast::IkSolutionList<IkReal> vsolutions;
    *isdone = 1;
    if(!ComputeIk(eetrans, eerot, NULL, vsolutions)) {
        *isdone = 0;
    }
    if(*isdone) {
        bool ret = false;
        vector<IkReal> sol(6);
        for(std::size_t i = 0; i < vsolutions.GetNumSolutions(); ++i) {
            vector<IkReal> vsolfree(vsolutions.GetSolution(i).GetFree().size());
            const ikfast::IkSolutionBase<IkReal>& solution = vsolutions.GetSolution(i);
            solution.GetSolution(&sol[0], vsolfree.size()>0?(&vsolfree[0]):NULL);
			if(checkArmLimit(sol)){
                for( std::size_t j = 0; j < sol.size(); ++j) {
                    jnts[j] = sol[j];
                }
				ret = true;
                break;
			}
       }
        if(!ret) {
            *isdone = 0;
        }
    }
}