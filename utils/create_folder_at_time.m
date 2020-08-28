function folder_path = create_folder_at_time(initial_path, folder_name)

    clk = clock;
    time_stamp = "date " + clk(1) + "-" + clk(2) + "-" + clk(3); 
    time_stamp = time_stamp + " time " + clk(4) + "-" + clk(5) + "-" + floor(clk(6));

    folder_name = folder_name + time_stamp;
    folder_path = initial_path + folder_name;
    mkdir(folder_path);

    folder_path = folder_path + "/";
end
