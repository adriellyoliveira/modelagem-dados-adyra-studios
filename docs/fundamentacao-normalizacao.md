# Fundamentação Teórica e Normalização — B-SIDE
# Yasmin Emiliano Alves

## 1. Fundamentação teórica

### 1.1. Modelos conceitual, lógico e físico

Modelo conceitual: representa de uma maneira geral, as informacões necessária para funcinamento do banco, sem se preocupar com os detalhes técnicos de implementação.

Modelo lógico: vai organizar os dados em uma estrutura que pode ser representada por tabelas, atributos, chaves primárias e estrangeiras. Aqui é definido as regras para relacionar e organizar as informações.

Modelo físico: etapa final da estruturação, aqui à implementação da estrutura de dados em um Sistema Gerenciador de Banco de Dados (SGBD), como o MySQL. Nessa etapa, são definidos os tipos de dados, as restrições e os comandos SQL utilizados para criar e configurar as tabelas.

No projeto B-SIDE, o modelo físico foi desenvolvido em MySQL, com tabelas destinadas ao armazenamento das informações dos usuários, das photocards, das coleções e dos recursos de gamificação. Essa estrutura permite armazenar os dados e estabelecer relações entre as informações utilizadas pelo sistema.


### 1.2. Chaves primárias e estrangeiras 

As chaves são utilizadas para identificar registros e estabelecer relações entre tabelas no banco de dados.

A chave primária (PK — Primary Key) é responsável por identificar cada registro de maneira única dentro de uma tabela. Ela não deve apresentar valores duplicados e não pode ser nula.

A chave estrangeira (FK — Foreign Key) é um campo que referencia uma chave de outra tabela, permitindo relacionar informações e contribuir para a integridade dos dados.

No B-SIDE, a tabela users possui o campo id como chave primária. Já a tabela photocards possui o campo collection_id, que referencia a tabela collections, e o campo member_id, que referencia a tabela members. 

Além disso, a tabela user_photocards utiliza uma chave primária composta por user_id e photocard_id, permitindo identificar cada associação entre um usuário e uma photocard.

Dentro do banco de dados, as chaves estrangeiras mantêm uma relação entre as tabelas, ajudando a referenciar registros de outras tabelas e garantindo a integridade dos dados. Elas permitem que as informações sejam conectadas de maneira organizada, evitando referências a registros inexistentes. No B-SIDE, por exemplo, a tabela `photocards` utiliza as chaves estrangeiras `collection_id` e `member_id` para se relacionar com as tabelas `collections` e `members`, respectivamente.


### 1.3. Relacionamentos e cardinalidade

Os relacionamentos representam as associações entre informações armazenadas no banco de dados. A cardinalidade determina quantas ocorrências podem estar relacionadas entre duas tabelas.

As principais cardinalidades são:

Um para um (1:1): um registro de uma tabela está associado a, no máximo, um registro de outra tabela.

Um para muitos (1): um registro de uma tabela pode estar associado a vários registros de outra tabela.

Muitos para muitos (N): vários registros de uma tabela podem estar associados a vários registros de outra tabela. Esse tipo de relacionamento normalmente utiliza uma tabela intermediária.

No B-SIDE, um artista pode estar associado a vários integrantes, caracterizando uma relação de um para muitos. Já usuários e photocards possuem uma relação de muitos para muitos, pois um usuário pode possuir várias cartas e uma mesma carta pode fazer parte da coleção de diferentes usuários. 

artista <-> integrantes          
                                     Essa associação é armazenada na tabela user_photocards.
usuàrios <-> photocards 

## 2. Normalização do banco de dados 

A normalização acontece de forma progressiva, assim só sendo possível atingir a segunda forma normal estando na primeira forma normal antes. 
Essa etapa impede que tenha informações redundantes, repetidas.

### 2.1. Primeira Forma Normal (1FN)

*A Primeira Forma Normal determina que cada campo deve armazenar um único valor, sem listas de informações ou grupos repetidos dentro de uma mesma célula.*

Por exemplo, uma tabela que armazena todas as photocards de um usuário em um único campo, como “Lisa, Jennie e Rosé”, não atende à 1FN. Para corrigir essa estrutura, cada associação entre usuário e photocard deve ser registrada individualmente.

No B-SIDE, a tabela user_photocards segue essa organização, pois cada registro contém um user_id, um photocard_id e a respectiva quantidade de cartas.

### 2.2. Segunda Forma Normal (2FN)

*A Segunda Forma Normal determina que a tabela deve estar na 1FN e que todos os atributos que não fazem parte da chave devem depender da chave primária completa, sem depender apenas de uma parte dela.*

> Essa regra é especialmente importante em tabelas que utilizam chaves primárias compostas. 

No B-SIDE, a tabela user_photocards possui uma chave primária composta pelos campos user_id e photocard_id. A quantidade armazenada nessa tabela depende da combinação entre o usuário e a photocard, pois diferentes usuários podem possuir quantidades distintas da mesma carta.

Caso o nome do usuário fosse armazenado nessa mesma tabela, ele dependeria apenas do identificador do usuário. Por isso, essa informação permanece na tabela users, evitando uma dependência parcial.


### 2.3. Terceira Forma Normal (3FN) + ## 2.4. Exemplo antes e depois da normalização

*A Terceira Forma Normal determina que a tabela deve estar na 2FN e não apresentar dependências transitivas entre atributos que não fazem parte da chave.*

Isso significa que informações que dependem de outro atributo não-chave devem ser organizadas de maneira adequada, evitando repetições desnecessárias.

No B-SIDE, os dados dos artistas são armazenados na tabela artists, enquanto os integrantes são registrados na tabela members. A tabela photocards referencia o integrante por meio do campo member_id, sem precisar repetir todas as informações do artista em cada registro de photocard.

Essa organização facilita a atualização dos dados e reduz a possibilidade de inconsistências causadas pela repetição de informações.

EX.  >>> | ID do usuário | Nome do usuário | Photocards | Quantidades |
         |     1        |    siyeonie      | Lisa, Jennie |   2, 1   |
          |    2         |   moa4ever       | Lisa, Rosé    | 1, 3   |

>>>> Essa estrutura apresenta um problema: os campos Photocards e Quantidades armazenam listas de valores. Isso dificulta a consulta e a atualização de informações e não atende à Primeira Forma Normal. <<<<<
A maneira correta seria fazer a separação dessas informações para não causar nenhum erro futuro.









