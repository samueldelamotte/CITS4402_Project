function answer = test(X,z)
%% Linear regression algorithm
nrows = 112/2; % downsample by half
ncols = 92/2;
Xnum = size(X,3);

z_ds = single(imresize(z,[nrows,ncols]));
y = z_ds(:)/255;

for ii = 1:Xnum
    Xi = squeeze(X(:,:,ii));
    y_hats(:,ii) = Xi*inv(Xi.'*Xi)*Xi.'*y;
end
d_ys = vecnorm(y-y_hats);
[dmin,i_class] = min(d_ys);
answer = i_class;

end

