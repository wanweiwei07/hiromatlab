point1measured = [0.5023, 0.4467, 1.221];
point2measured = [0.5018, -0.1308, 1.225];
point3measured = [-0.3651, -0.1447, 1.234];
point4measured = [-0.3616, 0.4314, 1.208];
point5measured = [0.1184, 0.2701, 1.187];
% point6measured = [-0.2815, 0.2731, 1.2];
point7measured = [-0.1694, 0.0774, 1.195];
movingpoints = [point1measured;point2measured;point3measured;point4measured;point5measured;point7measured]';

point1real = [0.12, 0.44, -0.5];
point2real = [0.72, 0.44, -0.5];
point3real = [0.72, -0.46, -0.5];
point4real = [0.12, -0.46, -0.5];
point5real = [0.3, -0.065, -0.2];
% point6real = [0.5, -0.235, -0.2];
point7real = [0.3, -0.285, -0.2];
fixedpoints = [point1real;point2real;point3real;point4real;point5real;point7real]';

[t, R] = callSVD(fixedpoints, movingpoints);


transformedpoints = bsxfun(@plus, R*movingpoints, t);