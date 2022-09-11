function [fitness,x_out,y_out,points_out,do_out,B_out] = fitness_robot(gene,fields)

% Generierunge des Spielfelds
% y*x große Matrix mit zufällig 1 und 2
% 2 steht für Dosen, 1 für leer

% Größe der Matrix durch b=y und a=x festlegen 
% (integer>0)
a           = 10;
b           = 10;

% 3-Dimensionale Matrix erstellen
A           = randi([1 2],a,b,fields);

% Maximale anzahl an zügen die der Roboter macht
% (integer>0)
actions     = 200;

% Startpunkt festelgen x,y,  wir starten immer bei (1,1) 
% (integer>0)
x_0         = 1;
y_0         = 1;

x           = x_0*ones(1,fields);
y           = y_0*ones(1,fields);

% Maritzen für schnellere Berechnungen erstellen
do          = zeros(actions,fields);
points      = zeros(actions,fields);
right       = zeros(actions,fields);
left        = zeros(actions,fields);
above       = zeros(actions,fields);
below       = zeros(actions,fields);
randomi_3_6 = zeros(actions,fields);
ap          = zeros(actions,fields);

used_actions = zeros(1,fields);

% Jedes Spielfeld mit Inputgene spielen
for ii = 1 : fields
    for jj = 1 : actions
        B(:,:,jj,ii) = A(:,:,ii);
        % herausfinden was left(jj,ii), right(jj,ii), above(jj,ii), below(jj,ii) von aktuellen
        % position ist
        [right(jj,ii),left(jj,ii),above(jj,ii),below(jj,ii),ap(jj,ii)] = umgebung_robot(y(jj,ii),x(jj,ii),a,b,A(:,:,ii));

        % Aktion aus Umgebung ableiten
        do(jj,ii) = gene(right(jj,ii),left(jj,ii),above(jj,ii),below(jj,ii),ap(jj,ii));

        %% Aktionen ausführen
        if do(jj,ii) == 1 % Aufeben
            A(y(jj,ii),x(jj,ii),ii) = A(y(jj,ii),x(jj,ii),ii) - 1;

            % Auf Postition bleiben
            y(jj+1,ii) = y(jj,ii);
            x(jj+1,ii) = x(jj,ii); 

            % Aufgehabove obwohl keine Dose da liegt, Minus 1 points
            if A(y(jj,ii),x(jj,ii),ii) == 0 
                A(y(jj,ii),x(jj,ii),ii) = 1;
                points(jj,ii) = -1;

            % Dose aufgehabove, Plus 10 points
            else 
                points(jj,ii) = 10;
            end

            
        elseif do(jj,ii) == 2 % Zufällig move
                randomi_3_6(jj,ii) = randi([3 6]);
                [x(jj+1,ii),y(jj+1,ii),points(jj,ii)]= move(x(jj,ii),y(jj,ii),a,b,randomi_3_6(jj,ii));
        else 
            [x(jj+1,ii),y(jj+1,ii),points(jj,ii)]= move(x(jj,ii),y(jj,ii),a,b,do(jj,ii));
        end
             
        %{
        % Wenn alle Dosen aufgesammelt sind Spielfeld beenden
        % und benutzte Züge notieren
        if sum(sum(A(:,:,ii))) == 2*a*b
            used_actions(1,ii) = jj;
            break
        else
            used_actions(1,ii) = actions;
        end
        
        
        % Auf Fehler überprüfen
        % wenn Dose aufheben (do=1) und sich bewegt wird
        if isequal(do(jj,ii),1) && (ne(x(jj+1,ii),x(jj,ii)) || ne(y(jj+1,ii),y(jj,ii)))
            do(jj,ii)
            x(jj,ii)
            x(jj+1,ii)
            y(jj,ii)
            y(jj+1,ii)
            error('Aktion Dose aufheben, aber position verändert sich')
            
            % wenn bewgen (do = 2,3,4,5,6) aber x/y ändert sich nicht und
            % keine negativen points
        elseif (isequal(do(jj,ii),2)||isequal(do(jj,ii),3)||isequal(do(jj,ii),4)||isequal(do(jj,ii),5)||isequal(do(jj,ii),6)) && (isequal(x(jj+1,ii),x(jj,ii)) && isequal(y(jj+1,ii),y(jj,ii))) && points(jj,ii) >= 0 
            do(jj,ii)
            x(jj,ii)
            x(jj+1,ii)
            y(jj,ii)
            y(jj+1,ii)
            points(jj,ii)
            error('Aktion Bewegung aber x/y ändert sich nicht und points sind 0/positiv')
        end
        %}
        

    end
 
    
end

fitness = 1/fields *(sum(sum(points)));
%+(2*a*b*fields-sum(used_actions))/4);
x_out = x(:,1);
y_out = y(:,1);
do_out = do(:,1);
points_out = points(:,1);
B_out = B(:,:,:,1);


end
