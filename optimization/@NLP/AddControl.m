function [nlp , grid_var] = AddControl(nlp, rbm, grid_var)


arguments
    nlp (1,1) NLP
    rbm (1,1) DynamicalSystem
    grid_var (1,1) struct
end




% idx is the number of the collocation point
%   e.g. idx = 0 means t = 0
for idx = 1:nlp.Settings.ncp
    
    nDouble=round(nlp.Settings.ncp/2);
    
    if idx<=nDouble
        NU = numel(rbm.Inputs.uD.sym);
        u_ub = rbm.Inputs.uD.UpperBound(:, idx);
        u_lb = rbm.Inputs.uD.LowerBound(:, idx);
        u_guess = rbm.Inputs.uD.Seed(:, idx);
        [nlp, u_idx] = AddVar(nlp, ['U_', num2str(idx)], NU, u_guess, u_lb, u_ub, 'input_D');
    else
        
        NU = numel(rbm.Inputs.uS.sym);
        u_ub = rbm.Inputs.uS.UpperBound(:, idx-nDouble);
        u_lb = rbm.Inputs.uS.LowerBound(:, idx-nDouble);
        u_guess = rbm.Inputs.uS.Seed(:, idx-nDouble);
        [nlp, u_idx] = AddVar(nlp, ['U_', num2str(idx)], NU, u_guess, u_lb, u_ub, 'input_S');
    end
    
    grid_var.(['input_', num2str(idx)]) = u_idx;
    
end


% add slew rate of actuators
if nlp.Problem.SlewRate.Bool
    
    for idx = 1:nlp.Settings.ncp
        
        du_ub = rbm.Inputs.du.UpperBound(:, idx);
        du_lb = rbm.Inputs.du.LowerBound(:, idx);
        du_guess = rbm.Inputs.du.Seed(:, idx);
        
        [nlp, du_idx] = AddVar(nlp, ['dU_', num2str(idx)], NU, du_guess, du_lb, du_ub, 'der_input');
        grid_var.(['der_input_', num2str(idx)]) = du_idx;
        
    end
    
    
end




end




