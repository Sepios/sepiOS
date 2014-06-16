function X = crossMx( v ) %#codegen
    %coder.inline('always');
    X=single((zeros(3,3)));                                 % set float type
    X(1,1) = 0.0;   X(1,2) = -v(3); X(1,3) = v(2);
    X(2,1) = v(3);  X(2,2) = 0.0;   X(2,3) = -v(1);
    X(3,1) = -v(2); X(3,2) = v(1);  X(3,3) = 0.0;
end

