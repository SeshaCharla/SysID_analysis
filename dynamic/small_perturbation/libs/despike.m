function omega_despiked = despike(omega_raw, spike_level)
     [n, m] = size(omega_raw);
     omega_despiked = zeros(n, m);
     for j = 2:n-1
         if (abs(omega_raw(j) - omega_raw(j-1)) > spike_level) && (abs(omega_raw(j) - omega_raw(j+1)) > spike_level)
                 omega_despiked(j) = (omega_raw(j-1)+omega_raw(j+1))/2;
         else
             omega_despiked(j) = omega_raw(j);
         end
     end
     omega_despiked(n) = omega_despiked(n-1);
     omega_despiked(1) = omega_despiked(2);
end