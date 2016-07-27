function [wrench, force] = getwrench( contactpoint, contactnorm, frictioncoeff, refcenter )
% calculate the wrench at a given contactpoint with given force direction
% it assumes the exerted force to be 1
%
% input
%----------
% - contactpoint - the exerting point of force, 1-by-2, [x, y].
% - contactnorm - the normal at contactpoint, 1-by-2, [x, y].
% - frictioncoeff - friction coefficent at this point, double.
% - refcenter - the rotation center to calculate moment, 1-by-2, [x,y].
%
% output
%----------
% - wrench - two wrenches caused by the force at this contactpoint, 2-by-3,
% [x, y, z].
% - force - two force that correpond to wrench, 2-by-2, [x, y], row-1: ccw to normal, row-2: cw to normal.
%
% author: Weiwei
% date: 20140110

    fangle = atan(frictioncoeff);
    tmatfccw = [[cos(-fangle), sin(-fangle)]; [-sin(-fangle), cos(-fangle)]];
    tmatfcw = [[cos(fangle), sin(fangle)]; [-sin(fangle), cos(fangle)]];

    % calculate force
    forceccw = contactnorm*(tmatfccw');
    forcecw = contactnorm*(tmatfcw');
    
    force = [forceccw; forcecw];
    
    % calculate wrench
    vec_refcenter2contact = refcenter - contactpoint;
    vec_contact2refcenter = contactpoint - refcenter;
    
    % wrench ccw
    vec_forceccw2refcenter = dot(vec_refcenter2contact, forceccw)*forceccw + vec_contact2refcenter;
    wrenchccw_z = cross([vec_forceccw2refcenter, 0], [forceccw, 0]);
    wrenchccw = [forceccw, wrenchccw_z(1, 3)];
    
    % wrench cw
    vec_forcecw2refcenter = dot(vec_refcenter2contact, forcecw)*forcecw + vec_contact2refcenter;
    wrenchcw_z = cross([vec_forcecw2refcenter, 0], [forcecw, 0]);
    wrenchcw = [forcecw, wrenchcw_z(1, 3)];
    
    wrench = [wrenchccw; wrenchcw];
    
end

