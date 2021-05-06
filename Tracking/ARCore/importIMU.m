function frames = importIMU(frames)
dirs                            = dir(strcat(frames.path,'*IMU.txt'));
filename                        = {dirs.name};
IMUdata                         = importdata([frames.path filename{1}]);
frames.IMU                      = IMUdata.data;