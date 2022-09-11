# Genetischer Algorithmus zur optimierung eines Stateless Putzroboters

Das Problem welches im Folgenden mit einem genetischen Algorithmus gelöst wird, stammt aus dem Buch Complexity von Melanie Mitchell.


<img src="/uploads/3ebb2e2e5c7f5395cb5ebbb1697209f4/Complexity.jpg" width="200">







**Problembeschreibung**

Es bewegt sich ein Stateless-Roboter (ohne Gedächtnis) auf einem Spielfeld von 10x10 Feldern.

<img src="https://raw.githubusercontent.com/testkompa/genetischer_algoritmus_roboter/main/visualisierung/ga_robot_gen_387.gif" width="350">

Auf jedem Feld liegt eine Dose(Blaue Felder) mit einer Wahrschenilichkeit von 50% .
Die Aufgabe des Roboters ist es das Spielfeld von den Dosen zu säubern(Blau zu Weiß). 
Um Dosen zu entfernen muss der Roboter auf die Felder gehen und die Dosen aufheben. 
Der Roboter startet immer Links oben im Spielfel und hat zu jedem Zeitpunkt 6 Optionen zur Handlung zu Verfügung.

1. Aufheben
2. In Zufallsrichtung bewegen
3. Nach Rechts bewegen
4. Nach Links bewegen
5. Nach Oben bewegen 
6. Nach Unten bewegen

Der Roboter sieht das Feld link,rechts,über,unter und as aktuelle Feld auf dem er steht.
Auf diesen Feldern kann er drei Dinge sehen.

1. Dose
2. Wand
3. Leeres Feld 

Er hat kein Gedächtnis (Stateless) und hat somit immer nur die Aktuellen Umgebungsiunformationen. 
Mit diesen Informationen muss er sich für eine der 6 Möglichkeiten entscheiden.
Die Handlungsanweiseungen werden in einem Vektor der Länge 243 festgehalten. Dort steht für jede Kombination der Umgebung eine Zahl von 1 bis 6 die bestimmt was der Roboter in dieser Situation machen soll. 

Der genetische Algorithmus bestimmt den perfekten Vector und damit die perfekte Handlungsweise des Roboters.

**Implementation**:

Das Skript `ga_robot` ist die eigene Implementation des genetischen algorithmus (in Matlab geschrieben).
Bestehend aus Fitness Bestimmung, Selection, Crossover und Mutation.

In der Section User Input können parameter wie Populationsgröße, Anzahl der Generationen, Anzahl der Spielfelder etc. vorgegeben werden.

**Startpopulation**

`population = initial_population_robot(population_size)`

Input:  Populationsgröße als INTEGER <br>
Output: Zufällige Startpopulation als 243xPopulationsgröße Matrix <br>

Beschreibung:<br>
Über die Funktion wird die Anfangspopulation mit dem Argument der Populationsgröße zufällig erstellt. Sie gibt eine 243xPopulationsgröße Matrix aus bei der jede Spalte eine Handlungsweise darstellt.

**Fitness**

`[fitness,x,y,points,do,B] = fitness_robot(gene_matrix,fields)`

Input:  Eine Handlungsweise als 3x3x3x3x3 Matrix, Anzahl der Spielfelder auf denen die Handlungsweise getestet wird<br>
Output: Fitness der Handlungsweise als FLOAT und weitere Informationen für die spätere Visualisierung

Beschreibung:<br>
Die Funktion mit dem Argument einer Handlungsweise und der Anzahl der zu wie oft die Handlungsweise getestet werden soll. Da die Dosen auf dem 10x10 Spielfeld zufällig verteilt werden, werden mehrere Runden mit der gleichen Handlungsweise getestet. Damit wird sicher gegangen, dass die getestete Handlungsweise nicht zufällig bei einer Dosenkonstellation gut abschneidet aber eigentlich für alle anderen unbrauchbar ist. Somit wird über die Anzahl der Runden die Fitness der Handlungsweise gemittelt und ausgegeben.
Dieser Vorgang wird für alle Handlungsweisen in der Population mit der parfor-Schleife parallel durchgeführt.

**Selection**

`[parent_gene_1,parent_gene_2] = selection_robot(population,fitness,selection_type,tournament_rounds)`

Input:  Gesamte Population als 243xPopulationsgröße Matrix, Fitness als 1xPopulationsgröße Vektor, Typ der Selection als Char, bei Typ `'tournament'` die Anzahl der Tournament Runden<br>
Output: 2 Handlunsgweisen jeweils als 243x1 Vektor<br>

Beschreibung: <br>
Die Funktion wählt zwei Handlungsweisen auf Basis der Fitness aus, die Später durch Crossover Kinder für die neue Generation schaffen. Als Argument Braucht die Funktion die Population, deren Fitness und den Typ der Selection. Als Output erhält zwei Handlungsweisen. Als Optionen für den Typ der Selection gibt es `'tournament'` und `'roulette'`. Bei der Option `'tournament'` werden zufällig zwei Handlungsweisen gewählt (mit replacement) und miteinander verglichen. Die mit der größeren Fitness gewinnt und wird gewählt. Das ganze wird 2 mal gemacht um 2 Eltern zu erhalten. Um besseren Handlungsweisen mehr Chancen zu geben als Eltern ausgewählt zu werden, kann die Anzahl der tournament Runden angepasst werden. Somit kann beispielsweise festgelegt werden, dass man erst ab 5 überstandenen Tunierunden als Elternteil gewählt wird.  <br>
Bei der Option `'roulette'` werden die Handlungsweisen Fitnessproportional ausgewählt. Weil Handlungsweisen auch negative Fitness haben können wird zuerst durch addieren des Betrags der negativten Handlungsweise in der Population sichergestellt das alle Fitness Werte positiv sind. 

**Crossover**

`child_gene = crossover_robot(parent_gene_1,parent_gene_2,crossover_type);`

Input: Bei der Selection ausgewählten Handlungsweisen 1&2 als 243x1 Vektor, Typ des Crossovers als Char <br>
Output: 2 Handlunsgweisen als 243x2 Matrix

Beschreibung: <br>
Bei der Funktion wird aus den beiden Eltern-Handlunsgweisen und dem Typ des Crossovers zwei Kinder-Handlunsgweisen. 
Als Optionen für den Typ des Corssover gibt es `'one_point'`,`'two_point'`,`'uniform'`. `'one_point'` Crossover tauscht Einträge der beiden Vektoren ab einem zufällig bestimmten Punkt. `'two_point'` Crossover Tauscht Einträge zwischen zwei zufällig bestimmten Punkten. `'uniform'` Crossover tauscht mit einer Whrscheinlichkeit von 50% jeden Eintrag zwischen den beiden Vektoren.

**Mutation**

`mutation_population = mutation_robot(population,p_mutation,mutation_type);`

Input: Population als 243xPopulationsgröße Matrix, Mutationswahrscheinlichkeit (parameter des Unser Inputs), Mutationstyp als Char <br>
Output: Die mutierte Population als 243xPopulationsgröße Matrix <br>

Beschreibung:<br>
Mit der Wahrscheinlichkeit p_mutation werden die Eintrage der Handlunsgweisen zufällig geändert. Als mutation_type gibt es nur `'normal'` als Auswahl.


**Visualisierung**

Mit dem Skipt `'visualisieren_robot_skript'` wird eine unter Auswahl einer Generation, einer Runde des putzenden Roboters visulaisiert. Unten stehened sind 3 gifs aus unterschiedlichen Generationen abgebildet.


<img src="https://raw.githubusercontent.com/testkompa/genetischer_algoritmus_roboter/main/visualisierung/ga_robot_gen_2.gif" width="350">

Generation = 2


<img src="https://raw.githubusercontent.com/testkompa/genetischer_algoritmus_roboter/main/visualisierung/ga_robot_gen_50.gif" width="350">

Generation = 50


<img src="https://raw.githubusercontent.com/testkompa/genetischer_algoritmus_roboter/main/visualisierung/ga_robot_gen_120.gif" width="350">

Generation = 120

<img src="https://raw.githubusercontent.com/testkompa/genetischer_algoritmus_roboter/main/visualisierung/ga_robot_gen_387.gif" width="350">

Generation = 387

Während dem Skipt ga_robot wird die Fitness über der Generation aufgetragen ( in rot die maximale Fitness der generation, in blau der Median der Fitness). Damit sieht man den Fortschritt des Roboters bis zur maximal möglichen Fitness von 500 (da im Schnitt 50 Dosen auf dem Spielfeld liegen und eine Dose 10 Punkte bringt, beträgt die maximale fitness 500)

<img src="https://raw.githubusercontent.com/testkompa/genetischer_algoritmus_roboter/main/visualisierung/git_plot.jpg" width="500">
