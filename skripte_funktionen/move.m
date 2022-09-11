function [x_neu,y_neu,punkt] = move(x,y,a,b,do)

if do == 3
    y_neu = y;
    x_neu = x + 1; 
    punkt = 0;

    % Gegen Wand gelaufen, Minus 5 Punkte
    if x_neu > b
        x_neu = b;
        punkt = -5;
    end

elseif do == 4
    y_neu = y;
    x_neu = x - 1; 
    punkt = 0;

    % Gegen Wand gelaufen, Minus 5 Punkte
    if x_neu < 1 
        x_neu = 1;
        punkt = -5;
    end

elseif do == 5
    y_neu = y - 1;
    x_neu = x; 
    punkt = 0;

    % Gegen Wand gelaufen, Minus 5 Punkte
    if y_neu < 1 
        y_neu = 1;
        punkt = -5;
    end
elseif do == 6
    y_neu = y + 1;
    x_neu = x; 
    punkt = 0;

    % Gegen Wand gelaufen, Minus 5 Punkte
    if y_neu > a 
        y_neu = a;
        punkt = -5;
    end
elseif do == 7
    y_neu = y;
    x_neu = x; 
    punkt = 0;
else
    disp(do)
    error('do~=3,4,5,6,7 in move function')
end


end