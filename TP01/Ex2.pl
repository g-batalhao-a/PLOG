pilot(lamb).
pilot(besenyei).
pilot(chambliss).
pilot(maclean).
pilot(mangold).
pilot(jones).
pilot(bonhomme).

team(lamb,breitling).
team(besenyei,redbull).
team(chambliss,redbull).
team(maclean,mediterranean).
team(mangold,cobra).
team(jones,matador).
team(bonhomme,matador).

plane(lamb,mx2).
plane(besenyei,edge540).
plane(chambliss,edge540).
plane(maclean,edge540).
plane(mangold,edge540).
plane(jones,edge540).
plane(bonhomme,edge540).

circuit(istanbul).
circuit(budapest).
circuit(porto).

won(jones,porto).
won(mangold,budapest).
won(mangold,istanbul).

numgates(istanbul,9).
numgates(budapest,6).
numgates(porto,5).

win(X,Y):-won(Z,Y),team(Z,X).