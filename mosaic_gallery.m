clear all
close all
clc

master_image_dir='XXXX';  %main image you want to mosaic
tile_image_dir='xxxx';  %tile image folder

OI=imread(master_image_dir);
[h,w,~]=size(OI);
downscale=10;
down_h=round(h/downscale);
down_w=round(w/downscale);
DI=imresize(OI,[down_h,down_w]);
figure
imshow(DI)
imds=imageDatastore(tile_image_dir);
particle_stock=cell(down_w*down_h,1);

for h_idx=1:down_h
    for w_idx=1:down_w
        particle_idx=w_idx+down_w*(h_idx-1);
        inv_title=readimage(imds,randi(length(imds.Files)));
        inv_title=inv_title(:,:,1);
        inv_title=imresize(inv_title,[10,10]);
        inv_title=double(inv_title)/255;



        R_part=double(DI(h_idx,w_idx,1));
        G_part=double(DI(h_idx,w_idx,2));
        B_part=double(DI(h_idx,w_idx,3));
%         colorMap_M = [linspace(0,R_part/255,256)', linspace(0,G_part/255,256)',...
%             linspace(0,B_part/255,256)'];
        colorcoded_inv_title(:,:,1)=inv_title/255*R_part;
        colorcoded_inv_title(:,:,2)=inv_title/255*G_part;
        colorcoded_inv_title(:,:,3)=inv_title/255*B_part;
%         for i=1:227
%             for j=1:227
%                 colorcoded_inv_title(i,j,:)=colorMap_M(inv_title(i,j)*255+1,:);
%             end
%         end
        particle_stock{particle_idx}=colorcoded_inv_title;
        progress=particle_idx/(down_w*down_h);

    end
       disp(strcat(num2str(progress*100),"% Completed"))
end

    out = imtile(particle_stock,'ThumbnailSize',[10,10],'GridSize',[round(h/downscale),round(w/downscale)]);
    figure
    imshow(out)
    imwrite(out,'Masaic.png')
