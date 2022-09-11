function [] = visualisieren_robot(A,x,y,do,punkte)

[~,~,c] = size(A);
x = x + 0.5;
y = y + 0.5;




for ii = 1:c
    


% Grid erstellen mit A
pcolor([A(:,:,ii), zeros(size(A(:,:,ii),1), 1); zeros(1, size(A(:,:,ii),2)+1)])


% Farben für Dosen und Hintergrund festlegen
dosen_farbe = [0.3010 0.7450 0.9330]; % blau
hintergrund_farbe = [0.8 0.8 0.8]; % grau

% Farben zuweisen
set(gca, 'CLim', [1 2]);
colormap(gca,[hintergrund_farbe ; dosen_farbe])

% Roboter Position 
text(x(ii),y(ii),'R', 'fontsize', 20)

% Achsennummerierung 
%set(gca, 'xtick', [])
%set(gca, 'ytick', [])

% Achsen Anpassen damit sie znu festgelegten Koordinatensystem passen
set(gca,'XAxisLocation','top','ydir','reverse')




% do und punkte in string für jeweiligen zug anzeigen
if ii == 1
    disp('Start des Spiels')
else
   % anzeigen = ['Aktion ',do_vektor(do(ii-1)),'   Punkte',num2str(punkte(ii-1))];
   if do(ii-1) == 1
       a = ['Aufheben'];
   elseif do(ii-1) == 2
       a = ['Zufall  '];
   elseif do(ii-1) == 3
       a = ['Rechts  '];
   elseif do(ii-1) == 4
       a = ['Links   '];
   elseif do(ii-1) == 5
       a = ['Oben    '];
   elseif do(ii-1) == 6
       a = ['Unten   '];
   elseif do(ii-1) == 7
       a = ['Stehen  '];
   end
   b = num2str(punkte(ii-1));
   anzeigen = ['Aktion ', a ,'   Punkte ', b];
   disp(anzeigen)     

end

drawnow

pause(2);
end