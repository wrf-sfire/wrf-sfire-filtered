function all_test
%plot_mesh_test
%block_example
disp('running all tests')
tol = 1e-9;
err=[
    check(@adj_mat_test),...
    check(@fun2mat_test),...
    check(@mlap3z_test),...
    check(@adj_test),...
    check(@mass_cons_int_test),...
    check(@poisson_fft3z_test),...
    check(@wind2flux_test),...
    check(@mat_wind_flux_div_test),...
    check(@mat_gen_wind_flux_div_test),...
    check(@mass_cons_flux_test)
    ];
max_err=max(err)
if max_err > tol, 
    warning(sprintf('error is %s too large for tolerance %s',max_err,tol))
else
    disp('all tests OK'),
end
    function err=check(f)
        err=f();
        if abs(err)>tol,
            warning(sprintf('error is %s too large for tolerance %s',err,tol))
        end
    end
end