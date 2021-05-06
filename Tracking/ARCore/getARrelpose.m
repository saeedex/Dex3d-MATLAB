function rpose = getARrelpose(frames)
if ~isfield(frames, 'ARposes'); return; end

tidx                            = floor(frames.v.CurrentTime*frames.v.FrameRate);
t1                              = frames.ARposes(tidx,2:4);
rotq1                           = [frames.ARposes(tidx,end) frames.ARposes(tidx,5:end-1)];
rotq1                           = quaternion(rotq1);
pose1                           = quat2pose(rotq1, t1);

tidx                            = floor(1+frames.v.CurrentTime*frames.v.FrameRate);
t2                              = frames.ARposes(tidx,2:4);
rotq2                           = [frames.ARposes(tidx,end) frames.ARposes(tidx,5:end-1)];
rotq2                           = quaternion(rotq2);
pose2                           = quat2pose(rotq2, t2);

rpose                           = relativepose(pose1, pose2);