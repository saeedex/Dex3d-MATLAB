function ncc = extractncc(img, win)
if isa(img, 'uint8')
img             = double(img)./255;
end
ncc.img         = img;
ncc.mimg        = imfilter(img,ones(win)/win/win,'same','symmetric','conv');
mimg2           = imfilter(img.^2,ones(win)/win/win,'same','symmetric','conv');
ncc.simg        = sqrt(mimg2-ncc.mimg.^2);
