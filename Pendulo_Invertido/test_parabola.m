%Test of the lowering order

%% Define the cart
cart  = InvertedPendulum(0.1,3*0.65,0.15);

%% Get parabola
par3 = cart.computeParabola(10,60);
