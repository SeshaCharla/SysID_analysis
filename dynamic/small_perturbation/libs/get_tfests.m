function tf_est = get_tfests(id_data, N)
    % Perform estimation using "sysinit" as template
    [Options, sysinit] = set_tfest_options();
    tf_est = {};
    for i=1:N
        tf_est{i} = tfest(id_data{i}, sysinit, Options);
    end
end