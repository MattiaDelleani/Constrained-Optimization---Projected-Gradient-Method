%% LOADING THE VARIABLES FOR THE TEST

clear 
clc
% Init. Armijo's parameters
 alpha0 = 1;
 c1 = 1e-4;
 rho = 0.8;
 btmax = 50;
 disp('**** PARAMETERS: alpha c1 rho btmax *****')
 format short  
 [alpha0 c1 rho btmax]

for n = [1e+4 , 1e+6]
    % Variables for data visualization
    iterations = zeros(6,1);
    time = zeros(6,1);
    
    res = zeros(6,1);
    fres = zeros(6,1);
    minx = zeros(6,1);
    i = 1;
   for a = [2, 4, 6, 8, 10, 12]

       tic
        x0 = rand(1,n)'+3*rand(1,n)'; % starting point outside the constraint
        
        kmax = 1000;
        
       
        tollgrad = 1e-12;
        h = 10^(-a);%*norm(x0);
        f = @(x)sum(1/4*x.^4 +1/2*x.^2-x);

        f_component = @(x) (1/4*x.^4 +1/2*x.^2-x);
        
        
        %finite difference
        gradf = @(x) findiff_grad(f_component, x, h, 'c'); % c: centered, fw: forward, None: exact der
        
       
        
        %set constraints
        mins= ones(n,1);
        maxs= ones(n,1)*2;

        %% RUN THE STEEPEST DESCENT
        % steepest descent params
        gamma = 0.1;
        tolx = 1e-6;
        
        % Projection function
        Pi_X = @(x) box_projection(x,mins,maxs);     
        
        [xk, fk, gradfk_norm, deltaxk_norm, k] = ...
            constr_steepest_desc_bcktrck(x0, f,  gradf, alpha0, kmax, ...
            tollgrad, c1, rho, btmax, gamma, tolx, Pi_X);
        
        % output
        time(i) = toc;
        iterations(i) = k;
        fres(i) = fk;
        minx(i) = min(xk);
        i = i+1;
        
   end
    disp(['**** STEEPEST DESCENT N:',num2str(n),' *****'])
    format short

   [time iterations minx fres/1e4]
end










