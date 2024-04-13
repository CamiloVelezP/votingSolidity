# Ejemplo de votación en solidity


El en este git podremos encontrar el código del contrato de votación.


Este está desplegado en la red de pruebas de sepolia en el siguiente enlace: https://sepolia.etherscan.io/tx/0x6b835ffd3849550a11d13b2fb0b2921c52295fb4ac08118a761dd24b2f58b054


si se desea probar se puede tomar el código definido en solidity llamado "voting.sol" y ponerlo en la IDE remix compilarlo con la versión 0.8.13 y desplegarlo usando una de las wallets de prueba.


## Funciones principales 


**Constructor:** En este se inicializan algunas variables del contrato, el dueño del contrato (que es simplemente quien despliega el contrato) y los tiempos de duración de la votación siendo el inicial el timestamp del momento en el que se despliega el contrato y el final será exactamente 3 días después.}


**Proposal:** Se crea una estructura de datos de una propuesta de votos que tiene nombre, número de votos y un booleano para revisar si existe o no esa propuesta, ya que usaremos un mapping para las propuestas seria útil para comprobar la existencia de una propuesta.


**onlyOwner:** es un modificador que revisa si quien ejecuto la función es el dueño del contrato, ya definido más arriba, se hace con un require que revisa la condición anterior y si no lo hace envía el mensaje "Only owner can do this".


**onlyWhitelisted:** es otro modificador que revisa si la dirección que envió la función está incluida en el mapping de la whitelist, esto se hace con un require que revisa la condición anterior y si no lo hace envía el mensaje "Address is not valid to vote".


**onlyDuringVotingPeriod:** es otro modificador que revisa que la función no se haya enviado después de que el tiempo de votación haya terminado, se hace con un require que revisa la condición si no se cumple se envía el mensaje "Voting period has already ended".


**addToWhitelist:** esta es una función, tiene el modificador onlyOwner por lo cual solo la puede ejecutar el dueño del contrato, esta función recibe una dirección como parámetro y hace que esta dirección que se mandó como parámetro tenga valor true en el mapping de la whitelist.


**removeFromWhitelist:** esta es una función, tiene el modificador onlyOwner por lo cual solo la puede ejecutar el dueño del contrato, esta función recibe una dirección como parámetro y hace que esta dirección que se mandó como parámetro se "elimine" del mapping que en otras palabras es volver al valor por default o vacío.


**addProposal:** esta función tiene  el modificador onlyOwner por lo cual solo la puede ejecutar el dueño del contrato, esta función recibe como parámetro un string que será el nombre de la propuesta, se declara como memory por que la necesitamos solo durante la ejecución de la función ya que la guardaremos dentro del mapping de la función, tiene un require que revisa que en el mapping de las propuestas, la propuesta que entra como parámetro tenga proposalExists en falso para revisar que la propuesta no exista, de otra manera se le enviará un mensaje de error "proposal already exists", una vez revisado que no existe en el mapping dicha propuesta simplemente vamos a llevar al mapping de las propuestas una nueva propuesta con el nombre que se envió como parámetro, 0 votos y true en proposalExist. 


**removeProposal:** esta función tiene el modificador onlyOwner por lo cual solo la puede ejecutar el dueño del contrato, esta función recibe como parámetro un string que será el nombre de la propuesta, se declara como memory por que la necesitamos solo durante la ejecución de la función, tiene un require que revisa que en el mapping de las propuestas, la propuesta que entra como parámetro tenga proposalExists en true para determinar que la propuesta a borrar si exista, de otra manera se enviara un mensaje de error "proposal does not exist", una vez que se revisa que si existe se "elimina" o mejor dicho ese valor en el mapping se vuelve a sus valores predeterminados.


**isValidToVote:** esta función tiene el modificador onlyWhitelisted por lo cual solo la podrá ejecutar aquellas direcciones que estén en la whitelist, también esta función retorna un booleano y está definida como view porque solo necesitamos leer datos y no modificarlos, esta función recibe como parámetro una dirección que será la dirección a revisar si puede votar, se hace un require en el cual se debe cumplir la condición de que en el mapping de "hasVoted" la dirección que se mandó como parámetro este en falso, lo cual indica que no ha votado, si no se cumple la condición se envía un mensaje de error "address is valid but has already voted", si esta condición se cumple la función retorna el valor booleano true


**vote:** esta función tiene el modificador onlyDuringVotingPeriod lo que significa que solo puede ser llamada mientras el periodo de votación este activo, recibe como parámetro un string que es la propuesta por la cual se desea votar, tiene un primer require que verifica si al llamar a la función isValidToVote con la dirección de quien envió la función devuelve true, de otra manera se envía un mensaje de error "address is not valid to vote", si esta condición se cumple se pasa a un segundo require que revisa que en el mapping de las propuestas, la propuesta que entra como parámetro tenga proposalExists en true para determinar que la propuesta a votar si exista, de otra manera se enviara un mensaje de error "proposal does not exist", si se cumple esta condición ahora si le sumaremos un voto buscando en el mapping de las propuestas la propiedad "voteCount" de esa propuesta enviada como parámetro y se hace que en el mapping de hasVoted esta dirección que envía la función se vuelva verdadera.


**endVotingPeriod:** esta función tiene el modificador onlyDuringVotingPeriod lo que significa que solo puede ser llamada mientras el periodo de votación este activo, esta función tiene el modificador onlyOwner por lo cual solo la puede ejecutar el dueño del contrato, lo que se hace es cambiar manualmente el final del tiempo de votación o mejor dicho la variable "endTime" al momento actual por lo cual cerrara la votación.


**isVotingPeriod:** esta función retorna un booleano y está definida como view porque solo necesitamos leer datos y no modificarlos, esta función lo que hace es retornar verdadero si el valor actual del timestamp es menor a lo que este definido como el tiempo final de votación o "endTime" de otra manera retornara falso.

**getProposalVoteCount:** recibe como parámetro un string que es la propuesta a la cual vamos a averiguar cuantos votos tiene, se declara como memory por que la necesitamos solo durante la ejecución de la función, está definida como view porque solo necesitamos leer datos y no modificarlos y retorna un entero que será la cantidad de votos de la propuesta que buscamos, lo que hace es buscar en el mapping de propuestas la propuesta enviada como parámetro, busca su parámetro "voteCount" y lo devuelve.
