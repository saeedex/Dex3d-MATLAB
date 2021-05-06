function cost = matchncc(nccL, nccR, win)
mimgRL  = imfilter(nccL.img.*nccR.img,ones(win)/win/win,'same','symmetric','conv');
cost    = abs(mimgRL-nccL.mimg.*nccR.mimg)./(nccL.simg.*nccR.simg);