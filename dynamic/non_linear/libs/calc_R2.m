function R2 = calc_R2(y, y_hat)
    y_hat = reshape(y_hat.', 1, []);
    y = reshape(y.', 1, []);
    R2 = 1 - ((sum((y-y_hat).^2))/(sum((y-mean(y)).^2)));
end