clear cam;

ncount = 50;
cam = webcam;
cam.Resolution = '640x640';

disp("Rock");
% Rock
for i=1:ncount
    img =  snapshot(cam);
    imshow(img);
    img_name = sprintf('images/rock/img_%3d.png', i);
    imwrite(img, img_name);
    disp(i);
end

pause(0.5);
disp("Paper");

% Paper
for i=1:ncount
    img = snapshot(cam);
    imshow(img);
    img_name = sprintf('images/paper/img_%3d.png', i);
    imwrite(img, img_name);
    disp(i);
end


pause(0.5);
disp("Scissors");
% Scissors
for i=1:ncount
    img =  snapshot(cam);
    imshow(img);
    img_name = sprintf('images/scissors/img_%3d.png', i);
    imwrite(img, img_name);
    disp(i);
end

disp("Done");

clear cam;