CREATE SEQUENCE sq_error;

CREATE TABLE PORCENTAJE_PROFESION
(cod_profesion NUMBER(5) NOT NULL, 
 asignacion NUMBER(5,2) NOT NULL,
 CONSTRAINT PK_PORCENTAJE_PROFESION PRIMARY KEY (cod_profesion));
 
CREATE TABLE errores_proceso (
   error_id NUMBER,
   mensaje_error_oracle varchar2(300),
   mensaje_error_usr VARCHAR2(300),
   CONSTRAINT pk_erroresproceso PRIMARY KEY (error_id)
);

CREATE TABLE afp (
  cod_afp NUMBER(1) NOT NULL,
  nombre_afp VARCHAR2(20) NOT NULL,
  porc NUMBER(5,2) NOT NULL,
  CONSTRAINT pk_afp PRIMARY KEY (cod_afp)
);

CREATE TABLE asesoria (
  numrun_prof NUMBER(10) NOT NULL,
  cod_empresa NUMBER NOT NULL, 
  honorario NUMBER NOT NULL
    CONSTRAINT ckc_sueldo_asesoria CHECK (honorario IS NULL OR (honorario <= 1000000)),  
  inicio_asesoria DATE NOT NULL, 
  fin_asesoria DATE NOT NULL,
  CONSTRAINT pk_asesoria PRIMARY KEY (numrun_prof, cod_empresa, inicio_asesoria)
);

CREATE TABLE comuna (
  cod_comuna NUMBER(5) NOT NULL, 
  nom_comuna VARCHAR2(20) NOT NULL,
  codemp_comuna NUMBER(2) NOT NULL,
  CONSTRAINT pk_comuna PRIMARY KEY (cod_comuna)
);

CREATE TABLE empresa (
  cod_empresa NUMBER(5) NOT NULL, 
  cod_comuna NUMBER(5) NOT NULL, 
  cod_sector NUMBER(5) NOT NULL, 
  nombre_empresa VARCHAR2(40) NOT NULL,
  CONSTRAINT pk_empresa PRIMARY KEY (cod_empresa)
);

CREATE TABLE isapre (
  cod_isapre NUMBER(1) NOT NULL, 
  nombre_isapre VARCHAR2(20) NOT NULL,
  CONSTRAINT pk_isapre PRIMARY KEY (cod_isapre)
);

CREATE TABLE profesion (
  cod_profesion NUMBER(5) NOT NULL, 
  nombre_profesion VARCHAR2(25) NOT NULL, 
  CONSTRAINT pk_profesion PRIMARY KEY (cod_profesion)
);

CREATE TABLE estado_civil(
  cod_estcivil NUMBER(1) NOT NULL, 
  desc_estcivil VARCHAR2(25) NOT NULL, 
  CONSTRAINT pk_estado_civil PRIMARY KEY (cod_estcivil)
);

CREATE TABLE profesional (
  numrun_prof NUMBER(10) NOT NULL, 
  dvrun_prof VARCHAR2(1) NOT NULL,
  cod_comuna NUMBER, 
  cod_profesion NUMBER NOT NULL, 
  appaterno VARCHAR2(15) NOT NULL, 
  apmaterno VARCHAR2(15) NOT NULL, 
  nombre VARCHAR2(20) NOT NULL, 
  cod_estcivil NUMBER(1) NOT NULL,
  puntaje number(3),
  sueldo NUMBER(8) NOT NULL, 
  cod_afp NUMBER(1) NOT NULL, 
  cod_isapre NUMBER(1) NOT NULL,
  cod_tpcontrato NUMBER(1),
  numrun_sup NUMBER(10),
  CONSTRAINT pk_profesional PRIMARY KEY (numrun_prof)
);

CREATE TABLE sector (
  cod_sector NUMBER(5) NOT NULL, 
  nombre_sector VARCHAR2(20) NOT NULL,
  CONSTRAINT pk_sector PRIMARY KEY (cod_sector)
);

CREATE TABLE tipo_contrato (
   cod_tpcontrato NUMBER(1) NOT NULL,
   nombre_tpcontrato VARCHAR2(30) NOT NULL,
   incentivo NUMBER(2) NOT NULL,
  CONSTRAINT pk_tipocontrato PRIMARY KEY (cod_tpcontrato)   
);

CREATE TABLE detalle_asignacion_mes(
mes_proceso  NUMBER(6) NOT NULL,
anno_proceso  NUMBER(6) NOT NULL,
run_profesional VARCHAR2(15) NOT NULL, 
nombre_profesional VARCHAR2(50) NOT NULL,
profesion VARCHAR2(30) NOT NULL,
nro_asesorias NUMBER(3) NOT NULL,
monto_honorarios NUMBER(8) NOT NULL,
monto_movil_extra NUMBER(8) NOT NULL,
monto_asig_tipocont NUMBER(8) NOT NULL,
monto_asig_profesion NUMBER(8) NOT NULL,
monto_total_asignaciones NUMBER(8) NOT NULL,
CONSTRAINT pk_detalle_asignacion_mes PRIMARY KEY(mes_proceso, anno_proceso, run_profesional)
);

CREATE TABLE resumen_mes_profesion (
anno_mes_proceso NUMBER(6) NOT NULL,
profesion varchar2(50) NOT NULL,
total_asesorias number(4) NOT NULL,
monto_total_honorarios NUMBER(8) NOT NULL,
monto_total_movil_extra NUMBER(8) NOT NULL,
monto_total_asig_tipocont NUMBER(8) NOT NULL,
monto_total_asig_prof NUMBER(8) NOT NULL,
monto_total_asignaciones NUMBER(8) NOT NULL,
CONSTRAINT pk_resumen_mes PRIMARY KEY(anno_mes_proceso, profesion)
);

  
ALTER TABLE empresa
   ADD CONSTRAINT fk_empresa_pertenece_sector FOREIGN KEY (cod_sector)
      REFERENCES sector (cod_sector);
      
ALTER TABLE empresa
   ADD CONSTRAINT fk_empresa_ubica_comuna FOREIGN KEY (cod_comuna)
      REFERENCES comuna (cod_comuna);

ALTER TABLE profesional
   ADD CONSTRAINT fk_profesional_vive_comuna FOREIGN KEY (cod_comuna)
      REFERENCES comuna (cod_comuna);

ALTER TABLE profesional
   ADD CONSTRAINT fk_profesional_profesion FOREIGN KEY (cod_profesion)
      REFERENCES profesion (cod_profesion);

ALTER TABLE profesional
   ADD CONSTRAINT fk_afp_profesional FOREIGN KEY (cod_afp)
      REFERENCES afp (cod_afp);

ALTER TABLE profesional
   ADD CONSTRAINT fk_isapre_profesional FOREIGN KEY (cod_isapre)
      REFERENCES isapre (cod_isapre);

ALTER TABLE profesional
   ADD CONSTRAINT fk_tcontrato_profesional FOREIGN KEY (cod_tpcontrato)
      REFERENCES tipo_contrato (cod_tpcontrato);

ALTER TABLE profesional
   ADD CONSTRAINT fk_estcivil_profesional FOREIGN KEY (cod_estcivil)
      REFERENCES estado_civil (cod_estcivil);

ALTER TABLE asesoria
   ADD CONSTRAINT fk_asesoria_profesional FOREIGN KEY (numrun_prof)
      REFERENCES profesional (numrun_prof);

ALTER TABLE asesoria
   ADD CONSTRAINT fk_asesoria_empresa FOREIGN KEY (cod_empresa)
      REFERENCES empresa (cod_empresa);
      

INSERT INTO tipo_contrato VALUES (1, 'Indefinido Jornada Completa', 15); 
INSERT INTO tipo_contrato VALUES (2, 'Indefinido Jornada Parcial', 10); 
INSERT INTO tipo_contrato VALUES (3, 'Plazo fijo', 5); 
INSERT INTO tipo_contrato VALUES (4, 'Honorarios', 5); 

INSERT INTO afp VALUES (1, 'CAPITAL',11.44);
INSERT INTO afp VALUES (2, 'CUPRUM',11.48);   
INSERT INTO afp VALUES (3, 'HABITAT',11.27); 
INSERT INTO afp VALUES (4, 'MODELO',10.77); 
INSERT INTO afp VALUES (5, 'PLANVITAL',12.36);
INSERT INTO afp VALUES (6, 'PROVIDA',11.54); 

INSERT INTO sector VALUES (1,'Comunicaciones');
INSERT INTO sector VALUES (2,'Servicios');
INSERT INTO sector VALUES (3,'Banca');
INSERT INTO sector VALUES (4,'Retail');

INSERT INTO estado_civil VALUES(1,'Soltero');
INSERT INTO estado_civil VALUES(2,'Casado');
INSERT INTO estado_civil VALUES(3,'Divorciado');
INSERT INTO estado_civil VALUES(4,'Viudo');

INSERT INTO comuna VALUES (80,'Las Condes', 50);
INSERT INTO comuna VALUES (81,'Providencia', 20);
INSERT INTO comuna VALUES (82,'Santiago', 10);
INSERT INTO comuna VALUES (83,'Ñuñoa', 10);
INSERT INTO comuna VALUES (84,'Vitacura', 30);
INSERT INTO comuna VALUES (85,'La Reina', 30);
INSERT INTO comuna VALUES (86,'La Florida', 20);
INSERT INTO comuna VALUES (87,'Maipú', 10);
INSERT INTO comuna VALUES (88,'Lo Barnechea', 40);
INSERT INTO comuna VALUES (89,'Macul', 20);
INSERT INTO comuna VALUES (90,'San Miguel', 20);
INSERT INTO comuna VALUES (91,'Peñalolén', 30);

INSERT INTO empresa VALUES (1,81,4,'Falabella');
INSERT INTO empresa VALUES (2,81,4,'Almacenes Paris');
INSERT INTO empresa VALUES (3,82,3,'Banco Santander');
INSERT INTO empresa VALUES (4,81,3,'Banco Estado');
INSERT INTO empresa VALUES (5,82,2,'Chilectra');
INSERT INTO empresa VALUES (6,82,2,'Aguas Andinas');
INSERT INTO empresa VALUES (7,81,2,'CGE');
INSERT INTO empresa VALUES (8,81,1,'Entel');
INSERT INTO empresa VALUES (9,81,1,'MaleStar');
INSERT INTO empresa VALUES (10,81,1,'Claro');
INSERT INTO empresa VALUES (11,81,2,'Enel');
INSERT INTO empresa VALUES (12,81,3,'Banco de Chile');

INSERT INTO isapre VALUES (1,'Masvida');
INSERT INTO isapre VALUES (2,'Vida Tres');
INSERT INTO isapre VALUES (3,'Banmédica');
INSERT INTO isapre VALUES (4,'Ferrosalud');
INSERT INTO isapre VALUES (5,'Colmena');
INSERT INTO isapre VALUES (6,'Consalud');
INSERT INTO isapre VALUES (7,'Cruz Blanca');

INSERT INTO profesion VALUES (1, 'Contador Auditor');
INSERT INTO profesion VALUES (2, 'Contador General');
INSERT INTO profesion VALUES (3, 'Ingeniero Informático');
INSERT INTO profesion VALUES (4, 'Ingeniero Prevencionista');
INSERT INTO profesion VALUES (5, 'Ingeniero Comercial');
INSERT INTO profesion VALUES (6, 'Ingeniero Industrial');
INSERT INTO profesion VALUES (7, 'Abogado');
INSERT INTO profesion VALUES (8, 'Arquitecto');

INSERT INTO PORCENTAJE_PROFESION VALUES (1, 12.3);
INSERT INTO PORCENTAJE_PROFESION VALUES (3, 14.36);
INSERT INTO PORCENTAJE_PROFESION VALUES (4, 21.34);
INSERT INTO PORCENTAJE_PROFESION VALUES (5, 14.32);
INSERT INTO PORCENTAJE_PROFESION VALUES (6, 22.44);
INSERT INTO PORCENTAJE_PROFESION VALUES (7, 12.36);
INSERT INTO PORCENTAJE_PROFESION VALUES (8, 18.23);      

--
/**/
--


INSERT INTO profesional VALUES ('20624895','4','80','1','Lester','Moran','Kisha','2','227','200000','5','3','3',NULL);
INSERT INTO profesional VALUES ('20652299','9','81','2','Bolton','Choi','Bradford','3','305','400000','4','6','3','17067642');
INSERT INTO profesional VALUES ('20718476','8','82','3','Sweeney','Landry','Stephanie','2','123','600000','4','3','3','17862825');
INSERT INTO profesional VALUES ('20823138','6','83','4','Morrow','Daniels','Noel','3','59','800000','4','4','3','18699786');
INSERT INTO profesional VALUES ('20823222','0','84','5','Morris','Ware','Devon','4','129','900000','4','2','3','18352172');
INSERT INTO profesional VALUES ('20899316','4','85','6','Randall','Bolton','Wanda','1','53','500000','5','2','3','19120175');
INSERT INTO profesional VALUES ('20930084','4','86','1','Joyce','Townsend','Hilary','2','198','300000','4','2','3','17896457');
INSERT INTO profesional VALUES ('21043583','2','87','2','Thornton','Pugh','Shane','3','311','2600000','1','2','3','18699786');
INSERT INTO profesional VALUES ('21047530','8',80,'3','Bates','Villegas','Regina','1','345','1100000','3','5','3','7873889');
INSERT INTO profesional VALUES ('6057969','6','89','4','Parsons','Marquez','Rachael','1','456','550000','4','6','3','7873889');
INSERT INTO profesional VALUES ('6275202','0','80','5','Frost','Pineda','Marci','3','112','700000','2','5','2','18829466');
INSERT INTO profesional VALUES ('6502066','1','81','6','Wilcox','Key','Leonard','1','387','600000','1','1','3',NULL);
INSERT INTO profesional VALUES ('6694138','K','82','1','Phelps','Shepherd','Marcie','3','339','300000','2','2','3','7168526');
INSERT INTO profesional VALUES ('6946767','8','83','2','Walton','Marquez','Melissa','1','138','1000000','5','1','2','17862825');
INSERT INTO profesional VALUES ('7034898','2','84','3','Gamble','Roman','Travis','3','220','1200000','5','5','2','7873889');
INSERT INTO profesional VALUES ('7168526','9','85','4','Gordon','Livingston','Latasha','2','159','400000','5','2','3','18699786');
INSERT INTO profesional VALUES ('7284220','2','86','5','Mc Intyre','Chung','Marla','3','311','300000','3','4','3','19100598');
INSERT INTO profesional VALUES ('7503210','4','87','6','Rubio','Sawyer','Dewayne','3','397','350000','3','5','3','7873889');
INSERT INTO profesional VALUES ('7744083','0','88','1','Pittman','Frost','Chris','1','412','1900000','4','1','1','16809546');
INSERT INTO profesional VALUES ('7873889','0','89','2','Harris','Wilcox','Teri','3','74','760000','2','4','2','18280709');
INSERT INTO profesional VALUES ('16612359','8','81','3','Booth','Parsons','Ronda','1','167','450000','3','6','3','17067642');
INSERT INTO profesional VALUES ('18280709','7',81,'4','Tucker','Hurst','Mark','3','254','280000','5','4','3','17067642');
INSERT INTO profesional VALUES ('18336158','9','82','5','Fletcher','Montgomery','Kendrick','1','140','490000','3','5','2','18352172');
INSERT INTO profesional VALUES ('18352172','6','81','6','Wells','Hanna','Malcolm','1','305','940000','3','6','2','19100598');
INSERT INTO profesional VALUES ('18390208','3','83','1','Bowers','Jordan','Juan','2','446','960000','2','4','1','19120175');
INSERT INTO profesional VALUES ('18421225','7','84','2','Fisher','Gross','Martin','3','366','980000','1','5','1','19120175');
INSERT INTO profesional VALUES ('18505021','0','85','3','Mc Millan','Schultz','Lynette','1','468','1000000','3','6','1','18352172');
INSERT INTO profesional VALUES ('18550492','7','86','4','Cordova','Dean','Bryon','2','79','1020000','3','4','1','17862825');
INSERT INTO profesional VALUES ('18659997','1','87','5','Shepherd','Herman','Jimmie','3','186','1040000','2','4','1','7168526');
INSERT INTO profesional VALUES ('18699786','7','87','6','Grant','Murray','Cassandra','1','252','1060000','3','4','1','18280709');
INSERT INTO profesional VALUES ('18804511','9','87','1','Burke','Howell','Jacob','2','199','1080000','1','6','1','17567043');
INSERT INTO profesional VALUES ('18829466','0','88','2','Kline','Mc Bride','Olivia','3','76','1100000','2','6','2','7005434');
INSERT INTO profesional VALUES ('18835559','4','89','3','Hardin','Wallace','Dora','1','442','1120000','3','5','2','18352172');
INSERT INTO profesional VALUES ('18839556','1','81','4','Beard','Mc Gee','Karla','2','120','1140000','2','2','2','18699786');
INSERT INTO profesional VALUES ('18934168','8','81','5','Ruiz','Hodges','Sylvia','3','189','1160000','3','4','2','18699786');
INSERT INTO profesional VALUES ('19100598','0','80','6','Solomon','Bowen','Rick','4','212','1180000','4','4','2','17067642');
INSERT INTO profesional VALUES ('19120175','K','80','1','Robles','Stafford','Helen','1','149','1200000','1','5','3',NULL);
INSERT INTO profesional VALUES ('19303268','2',82,'2','Reeves','Mack','Gabrielle','2','479','1220000','4','2','3','7168526');
INSERT INTO profesional VALUES ('19567994','2','82','3','Choi','Keller','Rachel','1','346','1280000','2','5','3','18280709');
INSERT INTO profesional VALUES ('19607698','K','82','4','Landry','Alvarado','Loretta','2','399','1300000','4','4','3','7005434');
INSERT INTO profesional VALUES ('19633374','3','82','5','Daniels','Larsen','Nicolas','3','125','1320000','1','4','3','18829466');
INSERT INTO profesional VALUES ('19639001','0','89','6','Ware','Cunningham','Clarence','1','114','1340000','2','6','3','16809546');
INSERT INTO profesional VALUES ('19664729','4','89','1','Bolton','Tucker','Derek','2','278','1360000','1','1','3','7168526');
INSERT INTO profesional VALUES ('19743237','9','89','2','Townsend','Fletcher','Moses','3','227','1380000','4','4','3','7005434');
INSERT INTO profesional VALUES ('19435555','8','89','3','Reyes','Roth','Wendi','3','145','1240000','1','3','3','19100598');
INSERT INTO profesional VALUES ('16641880','0','84','4','Hendricks','Richards','Jonathan','2','303','220000','4','4',2,'17567043');
INSERT INTO profesional VALUES ('16690718','3','84','5','Christian','Frost','Billie','3','285','240000','4','5',1,'16809546');
INSERT INTO profesional VALUES ('16723459','7','84','6','Solis','Petty','Devin','4','60','260000','2','5',2,NULL);
INSERT INTO profesional VALUES ('16764496','8','85','1','Mccoy','Wilcox','Sylvia','1','115','280000','4','3','3','19100598');
INSERT INTO profesional VALUES ('16874219','K',85,'2','Huang','Phelps','Christy','3','365','320000','4','2','3','17067642');
INSERT INTO profesional VALUES ('17067642','7','85','3','Shepard','Carney','Herman','4','210','340000','5','3',3,'19100598');
INSERT INTO profesional VALUES ('17204426','5','86','4','Trujillo','Friedman','Aaron','2','306','380000','1','5','3','16809546');
INSERT INTO profesional VALUES ('17237023','3','86','5','Lang','Villanueva','Jody','1','403','420000','3','5','4','18699786');
INSERT INTO profesional VALUES ('17264208','K','86','6','Montgomery','Mc Intyre','Randy','3','498','460000','5','2','2','7005434');
INSERT INTO profesional VALUES ('17393265','9','87','1','Hanna','Cruz','Kristen','2','114','480000','2','3','2','17067642');
INSERT INTO profesional VALUES ('17467536','3',80,'2','Jordan','Rubio','Justin','3','173','500000','1','4','3',NULL);
INSERT INTO profesional VALUES ('17511566','6','87','3','Gross','Marquez','Trisha','4','171','520000','3','3','3','16809546');
INSERT INTO profesional VALUES ('17567043','0','88','4','Schultz','Pittman','Randall','1','91','540000','2','5','3','7873889');
INSERT INTO profesional VALUES ('17598097','8','88','5','Dean','Pineda','Christie','2','88','560000','2','4','2','7873889');
INSERT INTO profesional VALUES ('17604208','9','88','6','Herman','Harris','Iris','3','265','580000','3','2','2','19100598');
INSERT INTO profesional VALUES ('17723898','5','81','1','Wallace','Booth','Enrique','1','254','660000','3','3','2','18280709');
INSERT INTO profesional VALUES ('17814206','2','82','2','Mc Gee','Hendricks','Bridget','2','347','680000','4','4','2','19120175');
INSERT INTO profesional VALUES ('17817690','7','80','3','Hodges','Christian','Felix','3','337','700000','4','2','1','18829466');
INSERT INTO profesional VALUES ('17862825','8','80','4','Bowen','Solis','Yvonne','1','287','720000','4','4','1','19100598');
INSERT INTO profesional VALUES ('17248479','4',83,'5','Hurst','Gordon','Wanda','2','76','440000','2','4','2','19120175');
INSERT INTO profesional VALUES ('17889317','3','80','6','Stafford','Mccoy','Alvin','1','252','740000','1','2','2','18280709');
INSERT INTO profesional VALUES ('17896457','9','82','1','Mack','Yoder','Bridgett','2','99','760000','1','2','2','17567043');
INSERT INTO profesional VALUES ('17909864','1','82','2','Roth','Huang','Penny','3','438','780000','2','5','1','7873889');
INSERT INTO profesional VALUES ('17934688','0','81','3','Gaines','Shepard','Rick','1','117','800000','4','6','1','18280709');
INSERT INTO profesional VALUES ('17950830','7','81','4','Keller','Fowler','Roberto','2','66','820000','3','6','1','18829466');
INSERT INTO profesional VALUES ('18014045','K','82','5','Alvarado','Trujillo','Rhonda','3','57','840000','5','2','1','18829466');
INSERT INTO profesional VALUES ('18156650','6','83','6','Larsen','Velasquez','Darlene','1','386','860000','4','3','1','18699786');
INSERT INTO profesional VALUES ('18184240','0','83','1','Cunningham','Lang','Courtney','2','461','880000','1','4','1','17896457');
INSERT INTO profesional VALUES ('19435837','5',84,'2','Moran','Gaines','Kirsten','4','190','1260000','4','4','1','17567043');
INSERT INTO profesional VALUES ('19770211','9','84','3','Pugh','Wells','Autumn','2','251','1400000','3','3','1','18352172');
INSERT INTO profesional VALUES ('19796164','2','85','4','Villegas','Bowers','Bridget','3','262','1420000','5','4','1','16809546');
INSERT INTO profesional VALUES ('19816444','4','85','5','Ballard','Fisher','Oscar','4','57','1440000','4','3','1','18699786');
INSERT INTO profesional VALUES ('19833967','5','86','6','Trevino','Mc Millan','Kendra','1','375','1460000','4','5','1',NULL);
INSERT INTO profesional VALUES ('19921273','6','86','1','White','Cordova','Tyler','1','315','1480000','2','2','1','19120175');
INSERT INTO profesional VALUES ('19952110','7',86,'2','Meyers','Shepherd','Teresa','2','61','1500000','2','2','1','19100598');
INSERT INTO profesional VALUES ('19987871','2','88','3','Meyer','Grant','Victoria','3','231','1520000','4','2','1','16809546');
INSERT INTO profesional VALUES ('20007856','3','88','4','Briggs','Burke','Natalie','4','179','800000','5','3','2','18280709');
INSERT INTO profesional VALUES ('20269498','9','88','5','Hines','Kline','Bonnie','1','335','500000','3','4','2','18699786');
INSERT INTO profesional VALUES ('20318058','K','89','6','Ortiz','Hardin','Audrey','2','89','300000','3','3','3','19100598');
INSERT INTO profesional VALUES ('20377241','9','90','1','Burke','Beard','Roger','3','250','500000','4','4','3','18699786');
INSERT INTO profesional VALUES ('20451244','6','91','2','Khan','Ruiz','Bret','4','263','300000','3','3','3','18829466');
INSERT INTO profesional VALUES ('20451888','6','82','3','Ward','Solomon','Erica','1','200','400000','3','5','3','7168526');
INSERT INTO profesional VALUES ('20528928','1','91','4','Benitez','Robles','Kelvin','2','113','150000','2','5','3','19120175');
INSERT INTO profesional VALUES ('20559425','9','91','1','Bean','Reeves','Jeannette','3','161','400000','3','4','2','19120175');
INSERT INTO profesional VALUES ('20608226','K','91','2','Dillon','Reyes','Ricardo','1','228','400000','2','3','2',NULL);
INSERT INTO profesional VALUES ('6269943','8','91','3','Richards','Pittman','Sheryl','2','427','300000','3','2','2','7873889');
INSERT INTO profesional VALUES ('6419034','9','91','4','Petty','Harris','Timothy','4','353','500000','5','5','2','18352172');
INSERT INTO profesional VALUES ('6506702','K','82','5','Chambers','Osborne','Leonard','2','326','700000','5','4','2','7005434');
INSERT INTO profesional VALUES ('6756480','2','81','6','Carney','Snow','Seth','4','184','900000','4','2','2','17567043');
INSERT INTO profesional VALUES ('7005434','0',81,'1','Friedman','Rios','Carmen','2','185','1100000','4','1','1','19120175');
INSERT INTO profesional VALUES ('7150191','9','82','2','Villanueva','Acevedo','Lewis','1','151','3300000','3','5','1','18699786');
INSERT INTO profesional VALUES ('7380283','5','80','3','Cruz','Boyle','Alisa','2','316','1600000','4','5','1','19100598');
INSERT INTO profesional VALUES ('7560327','1','80','4','Marquez','Richards','Rochelle','4','326','400000','4','1','2','17896457');
INSERT INTO profesional VALUES ('7860078','9','80','5','Pineda','Petty','Darius','2','165','2000000','1','4','1','16809546');
INSERT INTO profesional VALUES ('16809546','5','80','6','Yoder','Chambers','Irene','2','212','300000','1','2','2','17896457');
INSERT INTO profesional VALUES ('17186610','4','83','1','Fowler','Walton','Yesenia','1','319','360000','2','5','2','16809546');
INSERT INTO profesional VALUES ('17233467','7','83','2','Velasquez','Gamble','Josh','3','292','400000','4','6','2','7005434');

INSERT INTO asesoria VALUES ('19639001','9','542752',TO_DATE('22/02/19','DD/MM/RR'),TO_DATE('07/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','8','121865',TO_DATE('24/02/19','DD/MM/RR'),TO_DATE('07/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','2','198091',TO_DATE('26/02/19','DD/MM/RR'),TO_DATE('21/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','7','333864',TO_DATE('28/02/19','DD/MM/RR'),TO_DATE('25/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','1','591151',TO_DATE('02/03/19','DD/MM/RR'),TO_DATE('05/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','5','617740',TO_DATE('04/03/19','DD/MM/RR'),TO_DATE('22/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','10','146483',TO_DATE('06/03/19','DD/MM/RR'),TO_DATE('12/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','3','202941',TO_DATE('08/03/19','DD/MM/RR'),TO_DATE('06/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','8','722591',TO_DATE('10/03/19','DD/MM/RR'),TO_DATE('01/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','10','894638',TO_DATE('12/03/19','DD/MM/RR'),TO_DATE('25/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','5','739031',TO_DATE('14/03/19','DD/MM/RR'),TO_DATE('12/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','1','167964',TO_DATE('16/03/19','DD/MM/RR'),TO_DATE('31/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','339131',TO_DATE('18/03/19','DD/MM/RR'),TO_DATE('08/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','1','130483',TO_DATE('20/03/19','DD/MM/RR'),TO_DATE('05/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','9','878739',TO_DATE('22/03/19','DD/MM/RR'),TO_DATE('10/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','9','714337',TO_DATE('24/03/19','DD/MM/RR'),TO_DATE('26/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','1','544210',TO_DATE('26/03/19','DD/MM/RR'),TO_DATE('11/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','7','801898',TO_DATE('28/03/19','DD/MM/RR'),TO_DATE('08/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','3','767840',TO_DATE('30/03/19','DD/MM/RR'),TO_DATE('21/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','9','579473',TO_DATE('01/04/19','DD/MM/RR'),TO_DATE('14/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','3','327023',TO_DATE('03/04/19','DD/MM/RR'),TO_DATE('30/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','5','351739',TO_DATE('05/04/19','DD/MM/RR'),TO_DATE('30/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','10','205052',TO_DATE('07/04/19','DD/MM/RR'),TO_DATE('22/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','2','525782',TO_DATE('09/04/19','DD/MM/RR'),TO_DATE('01/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','6','515677',TO_DATE('11/04/19','DD/MM/RR'),TO_DATE('18/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','7','477987',TO_DATE('13/04/19','DD/MM/RR'),TO_DATE('27/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','4','814770',TO_DATE('15/04/19','DD/MM/RR'),TO_DATE('01/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','8','144238',TO_DATE('17/04/19','DD/MM/RR'),TO_DATE('28/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','8','288303',TO_DATE('19/04/19','DD/MM/RR'),TO_DATE('05/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','5','668566',TO_DATE('21/04/19','DD/MM/RR'),TO_DATE('18/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','7','193234',TO_DATE('23/04/19','DD/MM/RR'),TO_DATE('20/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','2','359536',TO_DATE('25/04/19','DD/MM/RR'),TO_DATE('11/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','9','708757',TO_DATE('27/04/19','DD/MM/RR'),TO_DATE('07/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','1','553094',TO_DATE('29/04/19','DD/MM/RR'),TO_DATE('11/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','4','645081',TO_DATE('01/05/19','DD/MM/RR'),TO_DATE('09/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','6','428713',TO_DATE('03/05/19','DD/MM/RR'),TO_DATE('14/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','3','698636',TO_DATE('05/05/19','DD/MM/RR'),TO_DATE('23/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','2','265960',TO_DATE('07/05/19','DD/MM/RR'),TO_DATE('06/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','3','534441',TO_DATE('09/05/19','DD/MM/RR'),TO_DATE('24/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','2','110385',TO_DATE('11/05/19','DD/MM/RR'),TO_DATE('24/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','1','470703',TO_DATE('13/05/19','DD/MM/RR'),TO_DATE('07/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','3','116601',TO_DATE('15/05/19','DD/MM/RR'),TO_DATE('14/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','6','861320',TO_DATE('17/05/19','DD/MM/RR'),TO_DATE('04/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','5','670694',TO_DATE('19/05/19','DD/MM/RR'),TO_DATE('14/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','3','355371',TO_DATE('21/05/19','DD/MM/RR'),TO_DATE('24/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','6','138755',TO_DATE('23/05/19','DD/MM/RR'),TO_DATE('20/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','10','408184',TO_DATE('25/05/19','DD/MM/RR'),TO_DATE('28/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','4','858744',TO_DATE('27/05/19','DD/MM/RR'),TO_DATE('07/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','7','331715',TO_DATE('29/05/19','DD/MM/RR'),TO_DATE('21/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','7','330518',TO_DATE('31/05/19','DD/MM/RR'),TO_DATE('22/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','9','600764',TO_DATE('02/06/19','DD/MM/RR'),TO_DATE('20/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','8','250373',TO_DATE('04/06/19','DD/MM/RR'),TO_DATE('28/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','3','417632',TO_DATE('06/06/19','DD/MM/RR'),TO_DATE('30/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','10','566387',TO_DATE('08/06/19','DD/MM/RR'),TO_DATE('24/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','7','293637',TO_DATE('10/06/19','DD/MM/RR'),TO_DATE('03/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','7','696556',TO_DATE('12/06/19','DD/MM/RR'),TO_DATE('19/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','6','717756',TO_DATE('14/06/19','DD/MM/RR'),TO_DATE('18/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','10','511779',TO_DATE('16/06/19','DD/MM/RR'),TO_DATE('03/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','1','629971',TO_DATE('18/06/19','DD/MM/RR'),TO_DATE('04/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','10','796736',TO_DATE('20/06/19','DD/MM/RR'),TO_DATE('02/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','3','207618',TO_DATE('22/06/19','DD/MM/RR'),TO_DATE('17/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','5','265387',TO_DATE('24/06/19','DD/MM/RR'),TO_DATE('08/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','4','105393',TO_DATE('26/06/19','DD/MM/RR'),TO_DATE('22/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','5','499282',TO_DATE('28/06/19','DD/MM/RR'),TO_DATE('25/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','9','239680',TO_DATE('30/06/19','DD/MM/RR'),TO_DATE('28/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','9','413439',TO_DATE('02/07/19','DD/MM/RR'),TO_DATE('23/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','3','146611',TO_DATE('04/07/19','DD/MM/RR'),TO_DATE('21/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','8','747119',TO_DATE('06/07/19','DD/MM/RR'),TO_DATE('26/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','6','823479',TO_DATE('08/07/19','DD/MM/RR'),TO_DATE('04/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','7','102646',TO_DATE('10/07/19','DD/MM/RR'),TO_DATE('18/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','6','839643',TO_DATE('12/07/19','DD/MM/RR'),TO_DATE('29/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','3','783640',TO_DATE('14/07/19','DD/MM/RR'),TO_DATE('08/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','9','262348',TO_DATE('16/07/19','DD/MM/RR'),TO_DATE('11/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','3','228929',TO_DATE('18/07/19','DD/MM/RR'),TO_DATE('14/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','8','258438',TO_DATE('20/07/19','DD/MM/RR'),TO_DATE('17/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','10','345755',TO_DATE('22/07/19','DD/MM/RR'),TO_DATE('11/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','6','562385',TO_DATE('24/07/19','DD/MM/RR'),TO_DATE('19/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','5','593104',TO_DATE('26/07/19','DD/MM/RR'),TO_DATE('24/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','2','788832',TO_DATE('28/07/19','DD/MM/RR'),TO_DATE('20/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','3','171552',TO_DATE('30/07/19','DD/MM/RR'),TO_DATE('17/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','5','531157',TO_DATE('01/08/19','DD/MM/RR'),TO_DATE('08/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','1','685773',TO_DATE('03/08/19','DD/MM/RR'),TO_DATE('24/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','2','280410',TO_DATE('05/08/19','DD/MM/RR'),TO_DATE('28/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','2','170132',TO_DATE('07/08/19','DD/MM/RR'),TO_DATE('12/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','5','397843',TO_DATE('09/08/19','DD/MM/RR'),TO_DATE('03/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','10','892739',TO_DATE('11/08/19','DD/MM/RR'),TO_DATE('21/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','420060',TO_DATE('13/08/19','DD/MM/RR'),TO_DATE('08/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','8','703448',TO_DATE('15/08/19','DD/MM/RR'),TO_DATE('12/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','10','446422',TO_DATE('17/08/19','DD/MM/RR'),TO_DATE('04/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','2','676642',TO_DATE('19/08/19','DD/MM/RR'),TO_DATE('13/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','9','146523',TO_DATE('21/08/19','DD/MM/RR'),TO_DATE('19/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','10','681168',TO_DATE('23/08/19','DD/MM/RR'),TO_DATE('30/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','7','291291',TO_DATE('25/08/19','DD/MM/RR'),TO_DATE('16/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','5','892313',TO_DATE('27/08/19','DD/MM/RR'),TO_DATE('01/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','6','426786',TO_DATE('29/08/19','DD/MM/RR'),TO_DATE('04/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','6','420535',TO_DATE('31/08/19','DD/MM/RR'),TO_DATE('21/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','6','833084',TO_DATE('02/09/19','DD/MM/RR'),TO_DATE('17/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','3','255801',TO_DATE('04/09/19','DD/MM/RR'),TO_DATE('12/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','1','564534',TO_DATE('06/09/19','DD/MM/RR'),TO_DATE('08/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','5','632044',TO_DATE('08/09/19','DD/MM/RR'),TO_DATE('23/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','3','598159',TO_DATE('10/09/19','DD/MM/RR'),TO_DATE('30/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','8','172231',TO_DATE('12/09/19','DD/MM/RR'),TO_DATE('08/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','2','563837',TO_DATE('14/09/19','DD/MM/RR'),TO_DATE('14/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','5','581411',TO_DATE('16/09/19','DD/MM/RR'),TO_DATE('21/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','8','269686',TO_DATE('18/09/19','DD/MM/RR'),TO_DATE('22/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','7','877572',TO_DATE('20/09/19','DD/MM/RR'),TO_DATE('20/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','10','831664',TO_DATE('22/09/19','DD/MM/RR'),TO_DATE('26/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','2','859088',TO_DATE('24/09/19','DD/MM/RR'),TO_DATE('28/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','8','566855',TO_DATE('26/09/19','DD/MM/RR'),TO_DATE('30/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','3','449988',TO_DATE('28/09/19','DD/MM/RR'),TO_DATE('30/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','8','805809',TO_DATE('30/09/19','DD/MM/RR'),TO_DATE('12/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','7','683179',TO_DATE('02/10/19','DD/MM/RR'),TO_DATE('08/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','8','204863',TO_DATE('04/10/19','DD/MM/RR'),TO_DATE('21/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','5','119854',TO_DATE('06/10/19','DD/MM/RR'),TO_DATE('25/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','10','602509',TO_DATE('08/10/19','DD/MM/RR'),TO_DATE('11/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','3','823005',TO_DATE('10/10/19','DD/MM/RR'),TO_DATE('28/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','1','763815',TO_DATE('12/10/19','DD/MM/RR'),TO_DATE('04/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','5','532448',TO_DATE('14/10/19','DD/MM/RR'),TO_DATE('27/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','10','627069',TO_DATE('16/10/19','DD/MM/RR'),TO_DATE('03/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','6','240133',TO_DATE('18/10/19','DD/MM/RR'),TO_DATE('08/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','7','452269',TO_DATE('20/10/19','DD/MM/RR'),TO_DATE('19/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','2','497021',TO_DATE('22/10/19','DD/MM/RR'),TO_DATE('04/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','2','589025',TO_DATE('24/10/19','DD/MM/RR'),TO_DATE('24/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','1','332274',TO_DATE('26/10/19','DD/MM/RR'),TO_DATE('01/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','8','426913',TO_DATE('28/10/19','DD/MM/RR'),TO_DATE('08/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','3','814658',TO_DATE('30/10/19','DD/MM/RR'),TO_DATE('03/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','9','705281',TO_DATE('01/11/19','DD/MM/RR'),TO_DATE('05/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','9','247801',TO_DATE('03/11/19','DD/MM/RR'),TO_DATE('19/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','3','666844',TO_DATE('05/11/19','DD/MM/RR'),TO_DATE('22/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','1','670251',TO_DATE('07/11/19','DD/MM/RR'),TO_DATE('03/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','8','346309',TO_DATE('09/11/19','DD/MM/RR'),TO_DATE('17/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','3','173971',TO_DATE('11/11/19','DD/MM/RR'),TO_DATE('02/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','5','130561',TO_DATE('13/11/19','DD/MM/RR'),TO_DATE('15/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','7','775607',TO_DATE('15/11/19','DD/MM/RR'),TO_DATE('24/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','8','325365',TO_DATE('17/11/19','DD/MM/RR'),TO_DATE('14/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','3','552939',TO_DATE('19/11/19','DD/MM/RR'),TO_DATE('07/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','4','353233',TO_DATE('21/11/19','DD/MM/RR'),TO_DATE('27/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','1','489300',TO_DATE('23/11/19','DD/MM/RR'),TO_DATE('02/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','10','399977',TO_DATE('25/11/19','DD/MM/RR'),TO_DATE('15/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','3','570409',TO_DATE('27/11/19','DD/MM/RR'),TO_DATE('01/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','1','756572',TO_DATE('29/11/19','DD/MM/RR'),TO_DATE('05/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','3','289458',TO_DATE('01/12/19','DD/MM/RR'),TO_DATE('27/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','3','666562',TO_DATE('03/12/19','DD/MM/RR'),TO_DATE('03/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','8','429303',TO_DATE('05/12/19','DD/MM/RR'),TO_DATE('22/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','9','525074',TO_DATE('07/12/19','DD/MM/RR'),TO_DATE('28/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','4','850746',TO_DATE('09/12/19','DD/MM/RR'),TO_DATE('04/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','5','161766',TO_DATE('11/12/19','DD/MM/RR'),TO_DATE('28/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','7','274746',TO_DATE('13/12/19','DD/MM/RR'),TO_DATE('21/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','2','240918',TO_DATE('15/12/19','DD/MM/RR'),TO_DATE('06/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','2','400131',TO_DATE('17/12/19','DD/MM/RR'),TO_DATE('08/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','7','291734',TO_DATE('19/12/19','DD/MM/RR'),TO_DATE('23/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','2','480463',TO_DATE('21/12/19','DD/MM/RR'),TO_DATE('14/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','6','119343',TO_DATE('23/12/19','DD/MM/RR'),TO_DATE('15/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','1','165746',TO_DATE('25/12/19','DD/MM/RR'),TO_DATE('13/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','6','683032',TO_DATE('27/12/19','DD/MM/RR'),TO_DATE('22/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','806064',TO_DATE('29/12/19','DD/MM/RR'),TO_DATE('16/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','5','895029',TO_DATE('31/12/19','DD/MM/RR'),TO_DATE('03/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','4','738477',TO_DATE('02/01/20','DD/MM/RR'),TO_DATE('10/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','5','833784',TO_DATE('04/01/20','DD/MM/RR'),TO_DATE('26/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','7','208145',TO_DATE('06/01/20','DD/MM/RR'),TO_DATE('20/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','4','895878',TO_DATE('08/01/20','DD/MM/RR'),TO_DATE('06/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','8','449304',TO_DATE('10/01/20','DD/MM/RR'),TO_DATE('09/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','10','503882',TO_DATE('12/01/20','DD/MM/RR'),TO_DATE('02/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','3','690568',TO_DATE('14/01/20','DD/MM/RR'),TO_DATE('18/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','7','693859',TO_DATE('16/01/20','DD/MM/RR'),TO_DATE('19/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','2','196708',TO_DATE('18/01/20','DD/MM/RR'),TO_DATE('03/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','2','418891',TO_DATE('20/01/20','DD/MM/RR'),TO_DATE('28/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','9','696108',TO_DATE('22/01/20','DD/MM/RR'),TO_DATE('10/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','1','417714',TO_DATE('24/01/20','DD/MM/RR'),TO_DATE('16/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','10','122780',TO_DATE('26/01/20','DD/MM/RR'),TO_DATE('10/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','7','559709',TO_DATE('28/01/20','DD/MM/RR'),TO_DATE('17/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','1','838376',TO_DATE('30/01/20','DD/MM/RR'),TO_DATE('21/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','3','396268',TO_DATE('01/02/20','DD/MM/RR'),TO_DATE('10/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','10','197666',TO_DATE('03/02/20','DD/MM/RR'),TO_DATE('08/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','6','692801',TO_DATE('05/02/20','DD/MM/RR'),TO_DATE('19/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','10','885154',TO_DATE('07/02/20','DD/MM/RR'),TO_DATE('06/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','1','343147',TO_DATE('09/02/20','DD/MM/RR'),TO_DATE('15/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','7','305247',TO_DATE('11/02/20','DD/MM/RR'),TO_DATE('08/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','5','457324',TO_DATE('13/02/20','DD/MM/RR'),TO_DATE('12/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','9','676999',TO_DATE('15/02/20','DD/MM/RR'),TO_DATE('08/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','3','681822',TO_DATE('17/02/20','DD/MM/RR'),TO_DATE('11/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','5','570282',TO_DATE('19/02/20','DD/MM/RR'),TO_DATE('29/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','5','796420',TO_DATE('21/02/20','DD/MM/RR'),TO_DATE('16/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','6','475414',TO_DATE('23/02/20','DD/MM/RR'),TO_DATE('13/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','10','633998',TO_DATE('25/02/20','DD/MM/RR'),TO_DATE('20/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','8','321906',TO_DATE('27/02/20','DD/MM/RR'),TO_DATE('19/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','7','654102',TO_DATE('28/02/20','DD/MM/RR'),TO_DATE('20/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','3','432520',TO_DATE('02/03/20','DD/MM/RR'),TO_DATE('16/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','6','203342',TO_DATE('04/03/20','DD/MM/RR'),TO_DATE('20/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','1','735579',TO_DATE('06/03/20','DD/MM/RR'),TO_DATE('21/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','5','130731',TO_DATE('08/03/20','DD/MM/RR'),TO_DATE('11/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','1','712966',TO_DATE('10/03/20','DD/MM/RR'),TO_DATE('24/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','7','334804',TO_DATE('12/03/20','DD/MM/RR'),TO_DATE('05/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','6','865066',TO_DATE('14/03/20','DD/MM/RR'),TO_DATE('05/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','3','788216',TO_DATE('16/03/20','DD/MM/RR'),TO_DATE('21/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','7','445069',TO_DATE('18/03/20','DD/MM/RR'),TO_DATE('14/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','7','706733',TO_DATE('20/03/20','DD/MM/RR'),TO_DATE('07/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','9','164829',TO_DATE('22/03/20','DD/MM/RR'),TO_DATE('24/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','5','401737',TO_DATE('24/03/20','DD/MM/RR'),TO_DATE('11/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','7','343766',TO_DATE('26/03/20','DD/MM/RR'),TO_DATE('13/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','4','221935',TO_DATE('28/03/20','DD/MM/RR'),TO_DATE('22/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','1','863254',TO_DATE('30/03/20','DD/MM/RR'),TO_DATE('29/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','5','160616',TO_DATE('01/04/20','DD/MM/RR'),TO_DATE('27/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','10','847914',TO_DATE('03/04/20','DD/MM/RR'),TO_DATE('03/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','5','156542',TO_DATE('05/04/20','DD/MM/RR'),TO_DATE('27/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','3','716956',TO_DATE('07/04/20','DD/MM/RR'),TO_DATE('28/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','7','602707',TO_DATE('09/04/20','DD/MM/RR'),TO_DATE('27/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','1','893474',TO_DATE('11/04/20','DD/MM/RR'),TO_DATE('01/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','1','642340',TO_DATE('13/04/20','DD/MM/RR'),TO_DATE('06/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','3','718841',TO_DATE('15/04/20','DD/MM/RR'),TO_DATE('03/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','9','414859',TO_DATE('17/04/20','DD/MM/RR'),TO_DATE('25/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','7','499194',TO_DATE('19/04/20','DD/MM/RR'),TO_DATE('17/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','1','268614',TO_DATE('21/04/20','DD/MM/RR'),TO_DATE('28/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','9','338703',TO_DATE('23/04/20','DD/MM/RR'),TO_DATE('01/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','8','719074',TO_DATE('25/04/20','DD/MM/RR'),TO_DATE('11/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','6','816224',TO_DATE('27/04/20','DD/MM/RR'),TO_DATE('21/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','9','220677',TO_DATE('29/04/20','DD/MM/RR'),TO_DATE('21/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','6','298872',TO_DATE('01/05/20','DD/MM/RR'),TO_DATE('18/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','7','879927',TO_DATE('03/05/20','DD/MM/RR'),TO_DATE('21/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','8','608004',TO_DATE('05/05/20','DD/MM/RR'),TO_DATE('04/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','9','632461',TO_DATE('07/05/20','DD/MM/RR'),TO_DATE('06/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','9','586931',TO_DATE('09/05/20','DD/MM/RR'),TO_DATE('19/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','3','397091',TO_DATE('11/05/20','DD/MM/RR'),TO_DATE('20/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','6','546948',TO_DATE('13/05/20','DD/MM/RR'),TO_DATE('02/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','9','369969',TO_DATE('15/05/20','DD/MM/RR'),TO_DATE('17/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','8','506984',TO_DATE('17/05/20','DD/MM/RR'),TO_DATE('18/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','2','205312',TO_DATE('19/05/20','DD/MM/RR'),TO_DATE('06/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','6','466301',TO_DATE('21/05/20','DD/MM/RR'),TO_DATE('18/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','4','413349',TO_DATE('23/05/20','DD/MM/RR'),TO_DATE('07/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','10','371793',TO_DATE('25/05/20','DD/MM/RR'),TO_DATE('09/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','10','810427',TO_DATE('27/05/20','DD/MM/RR'),TO_DATE('02/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','10','210503',TO_DATE('29/05/20','DD/MM/RR'),TO_DATE('28/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','8','227858',TO_DATE('31/05/20','DD/MM/RR'),TO_DATE('18/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','9','518405',TO_DATE('02/06/20','DD/MM/RR'),TO_DATE('04/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','8','206454',TO_DATE('04/06/20','DD/MM/RR'),TO_DATE('27/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','4','835817',TO_DATE('06/06/20','DD/MM/RR'),TO_DATE('01/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','2','823279',TO_DATE('08/06/20','DD/MM/RR'),TO_DATE('30/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','3','548284',TO_DATE('10/06/20','DD/MM/RR'),TO_DATE('04/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','2','498774',TO_DATE('12/06/20','DD/MM/RR'),TO_DATE('30/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','2','532152',TO_DATE('14/06/20','DD/MM/RR'),TO_DATE('08/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','4','362497',TO_DATE('16/06/20','DD/MM/RR'),TO_DATE('02/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','5','495252',TO_DATE('18/06/20','DD/MM/RR'),TO_DATE('23/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','10','752327',TO_DATE('20/06/20','DD/MM/RR'),TO_DATE('25/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','7','213439',TO_DATE('22/06/20','DD/MM/RR'),TO_DATE('15/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','1','543268',TO_DATE('24/06/20','DD/MM/RR'),TO_DATE('10/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','4','601971',TO_DATE('26/06/20','DD/MM/RR'),TO_DATE('15/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','1','269593',TO_DATE('28/06/20','DD/MM/RR'),TO_DATE('03/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','6','355113',TO_DATE('30/06/20','DD/MM/RR'),TO_DATE('14/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','3','665745',TO_DATE('02/07/20','DD/MM/RR'),TO_DATE('04/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','2','654827',TO_DATE('04/07/20','DD/MM/RR'),TO_DATE('24/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','10','443406',TO_DATE('06/07/20','DD/MM/RR'),TO_DATE('22/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','9','321795',TO_DATE('08/07/20','DD/MM/RR'),TO_DATE('31/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','4','549042',TO_DATE('10/07/20','DD/MM/RR'),TO_DATE('05/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','1','335232',TO_DATE('12/07/20','DD/MM/RR'),TO_DATE('16/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','4','691152',TO_DATE('14/07/20','DD/MM/RR'),TO_DATE('17/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','3','279352',TO_DATE('16/07/20','DD/MM/RR'),TO_DATE('31/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','10','243333',TO_DATE('18/07/20','DD/MM/RR'),TO_DATE('02/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','7','390529',TO_DATE('20/07/20','DD/MM/RR'),TO_DATE('04/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','9','309582',TO_DATE('22/07/20','DD/MM/RR'),TO_DATE('31/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','9','263393',TO_DATE('24/07/20','DD/MM/RR'),TO_DATE('17/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','2','288924',TO_DATE('26/07/20','DD/MM/RR'),TO_DATE('08/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','3','544089',TO_DATE('28/07/20','DD/MM/RR'),TO_DATE('17/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','8','779605',TO_DATE('30/07/20','DD/MM/RR'),TO_DATE('14/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','7','704512',TO_DATE('01/08/20','DD/MM/RR'),TO_DATE('28/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','10','450277',TO_DATE('03/08/20','DD/MM/RR'),TO_DATE('17/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','9','324249',TO_DATE('05/08/20','DD/MM/RR'),TO_DATE('21/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','108535',TO_DATE('07/08/20','DD/MM/RR'),TO_DATE('18/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','10','586520',TO_DATE('09/08/20','DD/MM/RR'),TO_DATE('28/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','7','414623',TO_DATE('11/08/20','DD/MM/RR'),TO_DATE('13/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','9','117325',TO_DATE('13/08/20','DD/MM/RR'),TO_DATE('05/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','1','595174',TO_DATE('15/08/20','DD/MM/RR'),TO_DATE('08/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','5','199396',TO_DATE('17/08/20','DD/MM/RR'),TO_DATE('01/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','9','819386',TO_DATE('19/08/20','DD/MM/RR'),TO_DATE('03/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','4','714436',TO_DATE('21/08/20','DD/MM/RR'),TO_DATE('18/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','2','262508',TO_DATE('23/08/20','DD/MM/RR'),TO_DATE('20/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','3','536141',TO_DATE('25/08/20','DD/MM/RR'),TO_DATE('13/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','2','308297',TO_DATE('27/08/20','DD/MM/RR'),TO_DATE('18/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','2','467768',TO_DATE('29/08/20','DD/MM/RR'),TO_DATE('24/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','9','168181',TO_DATE('31/08/20','DD/MM/RR'),TO_DATE('24/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','3','253456',TO_DATE('02/09/20','DD/MM/RR'),TO_DATE('23/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','7','878802',TO_DATE('04/09/20','DD/MM/RR'),TO_DATE('19/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','10','739894',TO_DATE('06/09/20','DD/MM/RR'),TO_DATE('13/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','5','618064',TO_DATE('08/09/20','DD/MM/RR'),TO_DATE('23/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','10','828460',TO_DATE('10/09/20','DD/MM/RR'),TO_DATE('25/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','9','233105',TO_DATE('12/09/20','DD/MM/RR'),TO_DATE('13/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','10','179586',TO_DATE('14/09/20','DD/MM/RR'),TO_DATE('29/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','7','845795',TO_DATE('16/09/20','DD/MM/RR'),TO_DATE('02/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','5','587423',TO_DATE('18/09/20','DD/MM/RR'),TO_DATE('19/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','5','804347',TO_DATE('20/09/20','DD/MM/RR'),TO_DATE('14/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','10','178452',TO_DATE('22/09/20','DD/MM/RR'),TO_DATE('15/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','4','313738',TO_DATE('24/09/20','DD/MM/RR'),TO_DATE('15/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','9','280697',TO_DATE('26/09/20','DD/MM/RR'),TO_DATE('09/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','7','723621',TO_DATE('28/09/20','DD/MM/RR'),TO_DATE('09/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','10','311508',TO_DATE('30/09/20','DD/MM/RR'),TO_DATE('27/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','10','246706',TO_DATE('02/10/20','DD/MM/RR'),TO_DATE('20/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','10','899218',TO_DATE('04/10/20','DD/MM/RR'),TO_DATE('23/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','10','603209',TO_DATE('06/10/20','DD/MM/RR'),TO_DATE('23/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','2','470879',TO_DATE('08/10/20','DD/MM/RR'),TO_DATE('26/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','3','617237',TO_DATE('10/10/20','DD/MM/RR'),TO_DATE('13/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','5','360064',TO_DATE('12/10/20','DD/MM/RR'),TO_DATE('15/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','8','221271',TO_DATE('14/10/20','DD/MM/RR'),TO_DATE('14/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','3','757122',TO_DATE('16/10/20','DD/MM/RR'),TO_DATE('24/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','4','710116',TO_DATE('18/10/20','DD/MM/RR'),TO_DATE('09/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','3','198617',TO_DATE('20/10/20','DD/MM/RR'),TO_DATE('02/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','7','619284',TO_DATE('22/10/20','DD/MM/RR'),TO_DATE('13/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','4','610606',TO_DATE('24/10/20','DD/MM/RR'),TO_DATE('22/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','1','764365',TO_DATE('26/10/20','DD/MM/RR'),TO_DATE('16/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','1','435511',TO_DATE('28/10/20','DD/MM/RR'),TO_DATE('20/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','5','833217',TO_DATE('30/10/20','DD/MM/RR'),TO_DATE('19/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','1','851301',TO_DATE('01/11/20','DD/MM/RR'),TO_DATE('05/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','3','420033',TO_DATE('03/11/20','DD/MM/RR'),TO_DATE('27/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','10','733478',TO_DATE('05/11/20','DD/MM/RR'),TO_DATE('31/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','5','721469',TO_DATE('07/11/20','DD/MM/RR'),TO_DATE('28/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','5','854008',TO_DATE('09/11/20','DD/MM/RR'),TO_DATE('29/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','5','327941',TO_DATE('11/11/20','DD/MM/RR'),TO_DATE('30/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','3','287065',TO_DATE('13/11/20','DD/MM/RR'),TO_DATE('19/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','559528',TO_DATE('15/11/20','DD/MM/RR'),TO_DATE('30/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','10','672416',TO_DATE('17/11/20','DD/MM/RR'),TO_DATE('17/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','6','155782',TO_DATE('19/11/20','DD/MM/RR'),TO_DATE('09/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','9','199183',TO_DATE('21/11/20','DD/MM/RR'),TO_DATE('14/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','5','803254',TO_DATE('23/11/20','DD/MM/RR'),TO_DATE('21/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','1','164173',TO_DATE('25/11/20','DD/MM/RR'),TO_DATE('07/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','4','812736',TO_DATE('27/11/20','DD/MM/RR'),TO_DATE('18/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','5','379067',TO_DATE('29/11/20','DD/MM/RR'),TO_DATE('31/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','2','817262',TO_DATE('01/12/20','DD/MM/RR'),TO_DATE('15/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','10','847994',TO_DATE('03/12/20','DD/MM/RR'),TO_DATE('23/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','9','217995',TO_DATE('07/12/20','DD/MM/RR'),TO_DATE('26/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','7','598548',TO_DATE('09/12/20','DD/MM/RR'),TO_DATE('25/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','9','115629',TO_DATE('11/12/20','DD/MM/RR'),TO_DATE('25/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','6','742284',TO_DATE('13/12/20','DD/MM/RR'),TO_DATE('11/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','2','248790',TO_DATE('15/12/20','DD/MM/RR'),TO_DATE('08/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','10','529268',TO_DATE('17/12/20','DD/MM/RR'),TO_DATE('17/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','9','764320',TO_DATE('19/12/20','DD/MM/RR'),TO_DATE('08/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','8','493077',TO_DATE('21/12/20','DD/MM/RR'),TO_DATE('05/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','1','306798',TO_DATE('23/12/20','DD/MM/RR'),TO_DATE('08/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','9','348129',TO_DATE('25/12/20','DD/MM/RR'),TO_DATE('16/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','3','701405',TO_DATE('27/12/20','DD/MM/RR'),TO_DATE('16/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','9','109061',TO_DATE('29/12/20','DD/MM/RR'),TO_DATE('22/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','2','775165',TO_DATE('03/01/20','DD/MM/RR'),TO_DATE('27/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','1','680943',TO_DATE('05/01/20','DD/MM/RR'),TO_DATE('23/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','9','152341',TO_DATE('07/01/20','DD/MM/RR'),TO_DATE('05/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','3','838771',TO_DATE('09/01/20','DD/MM/RR'),TO_DATE('19/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','10','695081',TO_DATE('11/01/20','DD/MM/RR'),TO_DATE('13/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','5','524760',TO_DATE('13/01/20','DD/MM/RR'),TO_DATE('27/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','10','769424',TO_DATE('15/01/20','DD/MM/RR'),TO_DATE('06/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','8','204033',TO_DATE('17/01/20','DD/MM/RR'),TO_DATE('30/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','1','445233',TO_DATE('19/01/20','DD/MM/RR'),TO_DATE('15/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','7','433104',TO_DATE('21/01/20','DD/MM/RR'),TO_DATE('09/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','3','218433',TO_DATE('23/01/20','DD/MM/RR'),TO_DATE('13/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','1','582372',TO_DATE('25/01/20','DD/MM/RR'),TO_DATE('06/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','5','387762',TO_DATE('27/01/20','DD/MM/RR'),TO_DATE('16/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','4','517784',TO_DATE('29/01/20','DD/MM/RR'),TO_DATE('28/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','3','192925',TO_DATE('31/01/20','DD/MM/RR'),TO_DATE('29/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','10','462246',TO_DATE('02/02/20','DD/MM/RR'),TO_DATE('06/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','1','652906',TO_DATE('04/02/20','DD/MM/RR'),TO_DATE('11/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','7','649532',TO_DATE('06/02/20','DD/MM/RR'),TO_DATE('22/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','5','879592',TO_DATE('08/02/20','DD/MM/RR'),TO_DATE('18/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','7','801581',TO_DATE('10/02/20','DD/MM/RR'),TO_DATE('20/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','5','674297',TO_DATE('12/02/20','DD/MM/RR'),TO_DATE('01/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','5','340685',TO_DATE('14/02/20','DD/MM/RR'),TO_DATE('06/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','10','376665',TO_DATE('16/02/20','DD/MM/RR'),TO_DATE('02/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','5','363666',TO_DATE('18/02/20','DD/MM/RR'),TO_DATE('12/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','2','647388',TO_DATE('20/02/20','DD/MM/RR'),TO_DATE('30/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','8','896039',TO_DATE('22/02/20','DD/MM/RR'),TO_DATE('09/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','1','421369',TO_DATE('24/02/20','DD/MM/RR'),TO_DATE('14/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','2','460500',TO_DATE('26/02/20','DD/MM/RR'),TO_DATE('21/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','1','871918',TO_DATE('28/02/20','DD/MM/RR'),TO_DATE('16/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','7','526792',TO_DATE('01/03/20','DD/MM/RR'),TO_DATE('28/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','1','791837',TO_DATE('03/03/20','DD/MM/RR'),TO_DATE('22/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','9','288685',TO_DATE('05/03/20','DD/MM/RR'),TO_DATE('27/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','7','471117',TO_DATE('07/03/20','DD/MM/RR'),TO_DATE('06/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','4','718842',TO_DATE('09/03/20','DD/MM/RR'),TO_DATE('18/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','9','708295',TO_DATE('11/03/20','DD/MM/RR'),TO_DATE('04/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','1','311021',TO_DATE('13/03/20','DD/MM/RR'),TO_DATE('04/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','10','396843',TO_DATE('15/03/20','DD/MM/RR'),TO_DATE('07/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','6','218337',TO_DATE('17/03/20','DD/MM/RR'),TO_DATE('26/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','9','162774',TO_DATE('19/03/20','DD/MM/RR'),TO_DATE('10/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','4','184059',TO_DATE('21/03/20','DD/MM/RR'),TO_DATE('08/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','2','101346',TO_DATE('23/03/20','DD/MM/RR'),TO_DATE('01/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','9','511252',TO_DATE('25/03/20','DD/MM/RR'),TO_DATE('19/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','9','535961',TO_DATE('27/03/20','DD/MM/RR'),TO_DATE('21/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','5','532895',TO_DATE('29/03/20','DD/MM/RR'),TO_DATE('17/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','8','263296',TO_DATE('31/03/20','DD/MM/RR'),TO_DATE('29/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','1','755583',TO_DATE('02/04/20','DD/MM/RR'),TO_DATE('31/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','4','328611',TO_DATE('04/04/20','DD/MM/RR'),TO_DATE('28/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','5','661163',TO_DATE('06/04/20','DD/MM/RR'),TO_DATE('30/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','2','255095',TO_DATE('08/04/20','DD/MM/RR'),TO_DATE('22/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','6','132659',TO_DATE('10/04/20','DD/MM/RR'),TO_DATE('27/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','3','544370',TO_DATE('12/04/20','DD/MM/RR'),TO_DATE('14/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','5','899177',TO_DATE('14/04/20','DD/MM/RR'),TO_DATE('12/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','5','655112',TO_DATE('16/04/20','DD/MM/RR'),TO_DATE('19/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','8','185781',TO_DATE('18/04/20','DD/MM/RR'),TO_DATE('08/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','3','206902',TO_DATE('20/04/20','DD/MM/RR'),TO_DATE('18/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','3','423340',TO_DATE('22/04/20','DD/MM/RR'),TO_DATE('07/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','7','397840',TO_DATE('24/04/20','DD/MM/RR'),TO_DATE('10/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','4','520326',TO_DATE('26/04/20','DD/MM/RR'),TO_DATE('22/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','9','455332',TO_DATE('28/04/20','DD/MM/RR'),TO_DATE('09/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','3','244028',TO_DATE('30/04/20','DD/MM/RR'),TO_DATE('20/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','9','188151',TO_DATE('02/05/20','DD/MM/RR'),TO_DATE('30/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','1','340053',TO_DATE('04/05/20','DD/MM/RR'),TO_DATE('07/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','1','248866',TO_DATE('06/05/20','DD/MM/RR'),TO_DATE('22/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','4','719069',TO_DATE('08/05/20','DD/MM/RR'),TO_DATE('06/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','7','300777',TO_DATE('10/05/20','DD/MM/RR'),TO_DATE('12/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','9','569678',TO_DATE('12/05/20','DD/MM/RR'),TO_DATE('02/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','9','899823',TO_DATE('14/05/20','DD/MM/RR'),TO_DATE('01/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','2','256317',TO_DATE('16/05/20','DD/MM/RR'),TO_DATE('30/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','2','471941',TO_DATE('18/05/20','DD/MM/RR'),TO_DATE('22/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','9','556085',TO_DATE('20/05/20','DD/MM/RR'),TO_DATE('12/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','1','308266',TO_DATE('22/05/20','DD/MM/RR'),TO_DATE('29/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','9','678526',TO_DATE('24/05/20','DD/MM/RR'),TO_DATE('12/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','6','281533',TO_DATE('26/05/20','DD/MM/RR'),TO_DATE('08/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','9','406199',TO_DATE('28/05/20','DD/MM/RR'),TO_DATE('18/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','6','168214',TO_DATE('30/05/20','DD/MM/RR'),TO_DATE('06/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','9','846343',TO_DATE('01/06/20','DD/MM/RR'),TO_DATE('02/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','6','561661',TO_DATE('03/06/20','DD/MM/RR'),TO_DATE('21/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','10','715440',TO_DATE('05/06/20','DD/MM/RR'),TO_DATE('25/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','1','719326',TO_DATE('07/06/20','DD/MM/RR'),TO_DATE('19/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','1','433907',TO_DATE('09/06/20','DD/MM/RR'),TO_DATE('30/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','1','347231',TO_DATE('11/06/20','DD/MM/RR'),TO_DATE('07/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','6','604463',TO_DATE('13/06/20','DD/MM/RR'),TO_DATE('20/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','6','102018',TO_DATE('15/06/20','DD/MM/RR'),TO_DATE('24/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','6','556884',TO_DATE('17/06/20','DD/MM/RR'),TO_DATE('16/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','10','641178',TO_DATE('19/06/20','DD/MM/RR'),TO_DATE('06/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','4','110817',TO_DATE('21/06/20','DD/MM/RR'),TO_DATE('11/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','1','682506',TO_DATE('23/06/20','DD/MM/RR'),TO_DATE('01/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','9','364220',TO_DATE('25/06/20','DD/MM/RR'),TO_DATE('26/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','5','838120',TO_DATE('27/06/20','DD/MM/RR'),TO_DATE('19/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','7','762415',TO_DATE('29/06/20','DD/MM/RR'),TO_DATE('13/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','4','899720',TO_DATE('01/07/20','DD/MM/RR'),TO_DATE('31/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','9','608048',TO_DATE('03/07/20','DD/MM/RR'),TO_DATE('12/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','7','833699',TO_DATE('05/07/20','DD/MM/RR'),TO_DATE('17/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','3','749055',TO_DATE('07/07/20','DD/MM/RR'),TO_DATE('31/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','3','128180',TO_DATE('09/07/20','DD/MM/RR'),TO_DATE('28/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','5','268285',TO_DATE('11/07/20','DD/MM/RR'),TO_DATE('13/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','1','735314',TO_DATE('13/07/20','DD/MM/RR'),TO_DATE('21/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','8','448003',TO_DATE('15/07/20','DD/MM/RR'),TO_DATE('14/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','8','599361',TO_DATE('17/07/20','DD/MM/RR'),TO_DATE('04/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','6','488924',TO_DATE('19/07/20','DD/MM/RR'),TO_DATE('28/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','2','760980',TO_DATE('21/07/20','DD/MM/RR'),TO_DATE('10/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','2','203949',TO_DATE('23/07/20','DD/MM/RR'),TO_DATE('14/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','5','863022',TO_DATE('25/07/20','DD/MM/RR'),TO_DATE('17/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','5','537213',TO_DATE('27/07/20','DD/MM/RR'),TO_DATE('03/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','2','328423',TO_DATE('29/07/20','DD/MM/RR'),TO_DATE('26/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','6','294221',TO_DATE('31/07/20','DD/MM/RR'),TO_DATE('20/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','10','490964',TO_DATE('02/08/20','DD/MM/RR'),TO_DATE('31/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','6','560886',TO_DATE('04/08/20','DD/MM/RR'),TO_DATE('05/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','5','602056',TO_DATE('06/08/20','DD/MM/RR'),TO_DATE('28/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','4','327940',TO_DATE('08/08/20','DD/MM/RR'),TO_DATE('06/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','7','659044',TO_DATE('10/08/20','DD/MM/RR'),TO_DATE('27/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','1','349532',TO_DATE('12/08/20','DD/MM/RR'),TO_DATE('04/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','6','741469',TO_DATE('14/08/20','DD/MM/RR'),TO_DATE('15/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','10','565076',TO_DATE('16/08/20','DD/MM/RR'),TO_DATE('04/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','9','603428',TO_DATE('18/08/20','DD/MM/RR'),TO_DATE('03/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','10','841262',TO_DATE('20/08/20','DD/MM/RR'),TO_DATE('27/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','2','112034',TO_DATE('22/08/20','DD/MM/RR'),TO_DATE('10/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','2','485476',TO_DATE('24/08/20','DD/MM/RR'),TO_DATE('16/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','4','253866',TO_DATE('26/08/20','DD/MM/RR'),TO_DATE('19/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','5','753995',TO_DATE('28/08/20','DD/MM/RR'),TO_DATE('04/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','1','511517',TO_DATE('30/08/20','DD/MM/RR'),TO_DATE('16/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','5','729399',TO_DATE('01/09/20','DD/MM/RR'),TO_DATE('07/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','4','790462',TO_DATE('03/09/20','DD/MM/RR'),TO_DATE('21/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','7','797312',TO_DATE('05/09/20','DD/MM/RR'),TO_DATE('24/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','7','213938',TO_DATE('07/09/20','DD/MM/RR'),TO_DATE('02/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','184195',TO_DATE('09/09/20','DD/MM/RR'),TO_DATE('27/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','5','813133',TO_DATE('11/09/20','DD/MM/RR'),TO_DATE('04/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','6','654382',TO_DATE('13/09/20','DD/MM/RR'),TO_DATE('21/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','3','485190',TO_DATE('15/09/20','DD/MM/RR'),TO_DATE('19/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','4','294369',TO_DATE('17/09/20','DD/MM/RR'),TO_DATE('12/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','8','852162',TO_DATE('19/09/20','DD/MM/RR'),TO_DATE('07/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','1','560238',TO_DATE('21/09/20','DD/MM/RR'),TO_DATE('09/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','7','664377',TO_DATE('23/09/20','DD/MM/RR'),TO_DATE('05/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','9','672473',TO_DATE('25/09/20','DD/MM/RR'),TO_DATE('20/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','2','418273',TO_DATE('27/09/20','DD/MM/RR'),TO_DATE('07/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','2','618619',TO_DATE('29/09/20','DD/MM/RR'),TO_DATE('02/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','1','782997',TO_DATE('01/10/20','DD/MM/RR'),TO_DATE('03/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','9','739812',TO_DATE('03/10/20','DD/MM/RR'),TO_DATE('05/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','7','301289',TO_DATE('05/10/20','DD/MM/RR'),TO_DATE('27/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','1','166877',TO_DATE('07/10/20','DD/MM/RR'),TO_DATE('21/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','1','238019',TO_DATE('09/10/20','DD/MM/RR'),TO_DATE('28/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','9','354358',TO_DATE('11/10/20','DD/MM/RR'),TO_DATE('01/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','8','562813',TO_DATE('13/10/20','DD/MM/RR'),TO_DATE('07/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','8','401940',TO_DATE('15/10/20','DD/MM/RR'),TO_DATE('24/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','1','435055',TO_DATE('17/10/20','DD/MM/RR'),TO_DATE('02/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','7','231782',TO_DATE('19/10/20','DD/MM/RR'),TO_DATE('30/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','9','788284',TO_DATE('21/10/20','DD/MM/RR'),TO_DATE('22/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','7','160041',TO_DATE('23/10/20','DD/MM/RR'),TO_DATE('09/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','2','779844',TO_DATE('25/10/20','DD/MM/RR'),TO_DATE('16/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','544337',TO_DATE('27/10/20','DD/MM/RR'),TO_DATE('01/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','1','650452',TO_DATE('29/10/20','DD/MM/RR'),TO_DATE('16/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','7','598173',TO_DATE('31/10/20','DD/MM/RR'),TO_DATE('30/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','2','642584',TO_DATE('02/11/20','DD/MM/RR'),TO_DATE('18/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','5','571854',TO_DATE('04/11/20','DD/MM/RR'),TO_DATE('07/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','4','344017',TO_DATE('06/11/20','DD/MM/RR'),TO_DATE('21/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','9','785907',TO_DATE('08/11/20','DD/MM/RR'),TO_DATE('07/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','6','235996',TO_DATE('10/11/20','DD/MM/RR'),TO_DATE('01/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','2','149412',TO_DATE('12/11/20','DD/MM/RR'),TO_DATE('12/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','4','655022',TO_DATE('14/11/20','DD/MM/RR'),TO_DATE('30/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','4','338979',TO_DATE('16/11/20','DD/MM/RR'),TO_DATE('05/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','6','192764',TO_DATE('18/11/20','DD/MM/RR'),TO_DATE('05/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','5','203609',TO_DATE('20/11/20','DD/MM/RR'),TO_DATE('08/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','7','570177',TO_DATE('22/11/20','DD/MM/RR'),TO_DATE('06/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','8','605734',TO_DATE('24/11/20','DD/MM/RR'),TO_DATE('12/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','10','373554',TO_DATE('26/11/20','DD/MM/RR'),TO_DATE('19/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','2','317444',TO_DATE('28/11/20','DD/MM/RR'),TO_DATE('20/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','9','153447',TO_DATE('30/11/20','DD/MM/RR'),TO_DATE('19/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','9','430475',TO_DATE('02/12/20','DD/MM/RR'),TO_DATE('10/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','5','831789',TO_DATE('04/12/20','DD/MM/RR'),TO_DATE('27/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','10','744869',TO_DATE('06/12/20','DD/MM/RR'),TO_DATE('22/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','7','313770',TO_DATE('08/12/20','DD/MM/RR'),TO_DATE('25/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','3','279669',TO_DATE('10/12/20','DD/MM/RR'),TO_DATE('02/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','8','593293',TO_DATE('12/12/20','DD/MM/RR'),TO_DATE('16/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','6','517527',TO_DATE('14/12/20','DD/MM/RR'),TO_DATE('10/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','9','443577',TO_DATE('16/12/20','DD/MM/RR'),TO_DATE('14/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','1','436623',TO_DATE('18/12/20','DD/MM/RR'),TO_DATE('06/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','7','510690',TO_DATE('20/12/20','DD/MM/RR'),TO_DATE('08/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','8','355751',TO_DATE('22/12/20','DD/MM/RR'),TO_DATE('20/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','7','644570',TO_DATE('24/12/20','DD/MM/RR'),TO_DATE('10/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','9','527586',TO_DATE('26/12/20','DD/MM/RR'),TO_DATE('28/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','6','134754',TO_DATE('28/12/20','DD/MM/RR'),TO_DATE('27/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','2','145963',TO_DATE('30/12/20','DD/MM/RR'),TO_DATE('17/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','7','132806',TO_DATE('17/07/21','DD/MM/RR'),TO_DATE('28/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','9','115804',TO_DATE('12/07/21','DD/MM/RR'),TO_DATE('31/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','10','690117',TO_DATE('15/07/21','DD/MM/RR'),TO_DATE('14/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','10','528445',TO_DATE('26/06/21','DD/MM/RR'),TO_DATE('03/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','6','283465',TO_DATE('07/07/21','DD/MM/RR'),TO_DATE('31/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','1','194808',TO_DATE('30/06/21','DD/MM/RR'),TO_DATE('25/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','10','855167',TO_DATE('28/06/21','DD/MM/RR'),TO_DATE('25/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','7','826896',TO_DATE('10/07/21','DD/MM/RR'),TO_DATE('20/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','1','151753',TO_DATE('19/07/21','DD/MM/RR'),TO_DATE('28/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','2','682970',TO_DATE('19/07/21','DD/MM/RR'),TO_DATE('13/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','7','486988',TO_DATE('04/07/21','DD/MM/RR'),TO_DATE('04/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','1','420349',TO_DATE('13/07/21','DD/MM/RR'),TO_DATE('22/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','7','178292',TO_DATE('23/07/21','DD/MM/RR'),TO_DATE('25/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','7','441800',TO_DATE('03/07/21','DD/MM/RR'),TO_DATE('15/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','5','118532',TO_DATE('12/07/21','DD/MM/RR'),TO_DATE('13/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','10','803426',TO_DATE('03/07/21','DD/MM/RR'),TO_DATE('23/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','3','874340',TO_DATE('22/07/21','DD/MM/RR'),TO_DATE('24/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','9','123152',TO_DATE('27/07/21','DD/MM/RR'),TO_DATE('02/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','3','506167',TO_DATE('28/07/21','DD/MM/RR'),TO_DATE('20/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','10','138705',TO_DATE('02/07/21','DD/MM/RR'),TO_DATE('25/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','5','210397',TO_DATE('14/07/21','DD/MM/RR'),TO_DATE('29/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','5','153403',TO_DATE('02/07/21','DD/MM/RR'),TO_DATE('14/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','10','627033',TO_DATE('14/07/21','DD/MM/RR'),TO_DATE('13/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','5','524511',TO_DATE('31/07/21','DD/MM/RR'),TO_DATE('28/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','4','380325',TO_DATE('07/07/21','DD/MM/RR'),TO_DATE('02/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','5','404939',TO_DATE('25/07/21','DD/MM/RR'),TO_DATE('29/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','8','628346',TO_DATE('18/07/21','DD/MM/RR'),TO_DATE('05/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','5','149562',TO_DATE('24/07/21','DD/MM/RR'),TO_DATE('23/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','6','415607',TO_DATE('28/07/21','DD/MM/RR'),TO_DATE('18/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','5','157314',TO_DATE('15/07/21','DD/MM/RR'),TO_DATE('06/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','1','836907',TO_DATE('21/07/21','DD/MM/RR'),TO_DATE('18/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','10','287712',TO_DATE('02/08/21','DD/MM/RR'),TO_DATE('01/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','10','308215',TO_DATE('10/07/21','DD/MM/RR'),TO_DATE('02/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','7','586575',TO_DATE('06/07/21','DD/MM/RR'),TO_DATE('28/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','5','344996',TO_DATE('01/08/21','DD/MM/RR'),TO_DATE('10/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','8','262119',TO_DATE('18/07/21','DD/MM/RR'),TO_DATE('13/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','5','727264',TO_DATE('21/07/21','DD/MM/RR'),TO_DATE('15/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','1','134312',TO_DATE('16/07/21','DD/MM/RR'),TO_DATE('03/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','6','604528',TO_DATE('31/07/21','DD/MM/RR'),TO_DATE('30/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','2','689406',TO_DATE('04/08/21','DD/MM/RR'),TO_DATE('25/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','10','565417',TO_DATE('20/07/21','DD/MM/RR'),TO_DATE('06/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','6','471818',TO_DATE('30/07/21','DD/MM/RR'),TO_DATE('30/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','6','667788',TO_DATE('07/08/21','DD/MM/RR'),TO_DATE('24/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','3','138333',TO_DATE('02/08/21','DD/MM/RR'),TO_DATE('22/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','3','777169',TO_DATE('22/07/21','DD/MM/RR'),TO_DATE('21/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','10','574919',TO_DATE('26/07/21','DD/MM/RR'),TO_DATE('16/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','6','868149',TO_DATE('17/07/21','DD/MM/RR'),TO_DATE('30/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','3','798988',TO_DATE('08/08/21','DD/MM/RR'),TO_DATE('25/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','5','861126',TO_DATE('13/07/21','DD/MM/RR'),TO_DATE('18/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','6','411834',TO_DATE('23/07/21','DD/MM/RR'),TO_DATE('15/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','10','712586',TO_DATE('03/08/21','DD/MM/RR'),TO_DATE('18/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','10','826026',TO_DATE('12/08/21','DD/MM/RR'),TO_DATE('11/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','7','824200',TO_DATE('04/08/21','DD/MM/RR'),TO_DATE('22/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','2','301678',TO_DATE('20/07/21','DD/MM/RR'),TO_DATE('21/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','2','620624',TO_DATE('07/08/21','DD/MM/RR'),TO_DATE('14/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','10','616164',TO_DATE('05/08/21','DD/MM/RR'),TO_DATE('20/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','3','293579',TO_DATE('26/07/21','DD/MM/RR'),TO_DATE('15/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','7','600815',TO_DATE('11/08/21','DD/MM/RR'),TO_DATE('19/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','8','800133',TO_DATE('16/08/21','DD/MM/RR'),TO_DATE('30/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','1','517439',TO_DATE('24/07/21','DD/MM/RR'),TO_DATE('08/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','5','214915',TO_DATE('25/07/21','DD/MM/RR'),TO_DATE('18/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','8','123301',TO_DATE('06/08/21','DD/MM/RR'),TO_DATE('02/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','9','450534',TO_DATE('14/08/21','DD/MM/RR'),TO_DATE('01/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','6','880729',TO_DATE('30/07/21','DD/MM/RR'),TO_DATE('12/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','7','121837',TO_DATE('29/07/21','DD/MM/RR'),TO_DATE('18/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','8','365876',TO_DATE('14/08/21','DD/MM/RR'),TO_DATE('04/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','204949',TO_DATE('09/08/21','DD/MM/RR'),TO_DATE('30/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','3','690358',TO_DATE('10/08/21','DD/MM/RR'),TO_DATE('22/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','2','235531',TO_DATE('27/07/21','DD/MM/RR'),TO_DATE('31/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','1','885287',TO_DATE('18/08/21','DD/MM/RR'),TO_DATE('22/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','10','241079',TO_DATE('17/08/21','DD/MM/RR'),TO_DATE('07/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','9','578398',TO_DATE('01/08/21','DD/MM/RR'),TO_DATE('06/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','10','122754',TO_DATE('09/08/21','DD/MM/RR'),TO_DATE('08/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','3','541640',TO_DATE('15/08/21','DD/MM/RR'),TO_DATE('11/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','6','158597',TO_DATE('10/08/21','DD/MM/RR'),TO_DATE('19/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','10','195404',TO_DATE('05/08/21','DD/MM/RR'),TO_DATE('15/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','1','172607',TO_DATE('29/07/21','DD/MM/RR'),TO_DATE('13/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','8','241832',TO_DATE('22/08/21','DD/MM/RR'),TO_DATE('27/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','4','383641',TO_DATE('26/08/21','DD/MM/RR'),TO_DATE('28/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','2','646747',TO_DATE('18/08/21','DD/MM/RR'),TO_DATE('07/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','9','575300',TO_DATE('13/08/21','DD/MM/RR'),TO_DATE('16/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','10','297059',TO_DATE('03/08/21','DD/MM/RR'),TO_DATE('26/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','3','365285',TO_DATE('13/08/21','DD/MM/RR'),TO_DATE('12/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','3','895835',TO_DATE('25/08/21','DD/MM/RR'),TO_DATE('15/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','3','172128',TO_DATE('11/08/21','DD/MM/RR'),TO_DATE('02/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','7','672879',TO_DATE('19/08/21','DD/MM/RR'),TO_DATE('08/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','3','261116',TO_DATE('15/08/21','DD/MM/RR'),TO_DATE('24/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','8','373106',TO_DATE('23/08/21','DD/MM/RR'),TO_DATE('06/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','6','497259',TO_DATE('24/08/21','DD/MM/RR'),TO_DATE('23/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','2','535719',TO_DATE('25/08/21','DD/MM/RR'),TO_DATE('17/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','4','679189',TO_DATE('23/08/21','DD/MM/RR'),TO_DATE('03/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','7','846728',TO_DATE('06/08/21','DD/MM/RR'),TO_DATE('18/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','8','723202',TO_DATE('26/08/21','DD/MM/RR'),TO_DATE('12/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','10','441746',TO_DATE('08/08/21','DD/MM/RR'),TO_DATE('23/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','3','667741',TO_DATE('02/09/21','DD/MM/RR'),TO_DATE('09/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','9','428706',TO_DATE('28/08/21','DD/MM/RR'),TO_DATE('28/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','6','834580',TO_DATE('04/09/21','DD/MM/RR'),TO_DATE('17/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','4','320690',TO_DATE('01/09/21','DD/MM/RR'),TO_DATE('17/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','2','533608',TO_DATE('06/09/21','DD/MM/RR'),TO_DATE('14/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','7','221338',TO_DATE('12/08/21','DD/MM/RR'),TO_DATE('04/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','2','526348',TO_DATE('20/08/21','DD/MM/RR'),TO_DATE('21/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','5','541412',TO_DATE('09/09/21','DD/MM/RR'),TO_DATE('20/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','8','242499',TO_DATE('22/08/21','DD/MM/RR'),TO_DATE('13/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','4','837046',TO_DATE('05/09/21','DD/MM/RR'),TO_DATE('12/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','6','591809',TO_DATE('21/08/21','DD/MM/RR'),TO_DATE('24/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','1','896174',TO_DATE('24/08/21','DD/MM/RR'),TO_DATE('14/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','1','271026',TO_DATE('17/08/21','DD/MM/RR'),TO_DATE('24/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','2','758093',TO_DATE('19/08/21','DD/MM/RR'),TO_DATE('19/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','8','603439',TO_DATE('30/08/21','DD/MM/RR'),TO_DATE('10/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','10','419843',TO_DATE('16/08/21','DD/MM/RR'),TO_DATE('04/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','9','772426',TO_DATE('30/08/21','DD/MM/RR'),TO_DATE('11/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','7','465701',TO_DATE('29/08/21','DD/MM/RR'),TO_DATE('07/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','5','627144',TO_DATE('20/08/21','DD/MM/RR'),TO_DATE('01/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','10','656242',TO_DATE('29/08/21','DD/MM/RR'),TO_DATE('10/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','10','191822',TO_DATE('21/08/21','DD/MM/RR'),TO_DATE('25/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','10','853418',TO_DATE('31/08/21','DD/MM/RR'),TO_DATE('15/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','4','560242',TO_DATE('19/09/21','DD/MM/RR'),TO_DATE('24/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','7','561343',TO_DATE('10/09/21','DD/MM/RR'),TO_DATE('01/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','9','514565',TO_DATE('15/09/21','DD/MM/RR'),TO_DATE('22/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','4','751758',TO_DATE('27/08/21','DD/MM/RR'),TO_DATE('10/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','8','179534',TO_DATE('27/08/21','DD/MM/RR'),TO_DATE('07/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','8','507848',TO_DATE('11/09/21','DD/MM/RR'),TO_DATE('08/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','3','746182',TO_DATE('03/09/21','DD/MM/RR'),TO_DATE('11/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','8','227835',TO_DATE('08/09/21','DD/MM/RR'),TO_DATE('31/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','7','577275',TO_DATE('21/09/21','DD/MM/RR'),TO_DATE('22/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','10','640213',TO_DATE('01/09/21','DD/MM/RR'),TO_DATE('15/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','1','738559',TO_DATE('12/09/21','DD/MM/RR'),TO_DATE('12/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','9','427592',TO_DATE('05/09/21','DD/MM/RR'),TO_DATE('25/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','5','357070',TO_DATE('31/08/21','DD/MM/RR'),TO_DATE('09/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','5','567659',TO_DATE('25/09/21','DD/MM/RR'),TO_DATE('17/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','3','317818',TO_DATE('20/09/21','DD/MM/RR'),TO_DATE('27/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','6','397653',TO_DATE('28/08/21','DD/MM/RR'),TO_DATE('28/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','5','158174',TO_DATE('08/09/21','DD/MM/RR'),TO_DATE('17/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','2','256946',TO_DATE('03/09/21','DD/MM/RR'),TO_DATE('29/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','10','663231',TO_DATE('21/09/21','DD/MM/RR'),TO_DATE('08/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','9','101589',TO_DATE('23/09/21','DD/MM/RR'),TO_DATE('26/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','2','455918',TO_DATE('04/09/21','DD/MM/RR'),TO_DATE('24/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','1','540502',TO_DATE('07/09/21','DD/MM/RR'),TO_DATE('02/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','4','546482',TO_DATE('25/09/21','DD/MM/RR'),TO_DATE('15/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','4','112325',TO_DATE('26/09/21','DD/MM/RR'),TO_DATE('03/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','5','292789',TO_DATE('02/09/21','DD/MM/RR'),TO_DATE('17/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','4','538747',TO_DATE('28/09/21','DD/MM/RR'),TO_DATE('26/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','8','626424',TO_DATE('23/09/21','DD/MM/RR'),TO_DATE('22/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','4','753757',TO_DATE('14/09/21','DD/MM/RR'),TO_DATE('09/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','1','421913',TO_DATE('28/09/21','DD/MM/RR'),TO_DATE('02/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','5','276237',TO_DATE('10/09/21','DD/MM/RR'),TO_DATE('15/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','7','314359',TO_DATE('20/09/21','DD/MM/RR'),TO_DATE('21/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','10','411138',TO_DATE('26/09/21','DD/MM/RR'),TO_DATE('16/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','3','315772',TO_DATE('13/09/21','DD/MM/RR'),TO_DATE('20/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','4','358892',TO_DATE('17/09/21','DD/MM/RR'),TO_DATE('01/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','3','186142',TO_DATE('06/09/21','DD/MM/RR'),TO_DATE('16/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','7','358668',TO_DATE('12/09/21','DD/MM/RR'),TO_DATE('05/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','1','331436',TO_DATE('09/09/21','DD/MM/RR'),TO_DATE('08/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','4','574809',TO_DATE('14/09/21','DD/MM/RR'),TO_DATE('21/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','2','812541',TO_DATE('07/09/21','DD/MM/RR'),TO_DATE('05/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','8','370277',TO_DATE('11/09/21','DD/MM/RR'),TO_DATE('10/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','2','811376',TO_DATE('27/09/21','DD/MM/RR'),TO_DATE('31/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','4','879010',TO_DATE('29/09/21','DD/MM/RR'),TO_DATE('04/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','3','759216',TO_DATE('02/10/21','DD/MM/RR'),TO_DATE('11/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','8','269376',TO_DATE('18/09/21','DD/MM/RR'),TO_DATE('02/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','7','889380',TO_DATE('04/10/21','DD/MM/RR'),TO_DATE('26/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','10','655191',TO_DATE('02/10/21','DD/MM/RR'),TO_DATE('28/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','3','150474',TO_DATE('24/09/21','DD/MM/RR'),TO_DATE('17/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','6','536770',TO_DATE('03/10/21','DD/MM/RR'),TO_DATE('23/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','4','163488',TO_DATE('24/09/21','DD/MM/RR'),TO_DATE('16/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','5','396442',TO_DATE('10/10/21','DD/MM/RR'),TO_DATE('10/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','7','228532',TO_DATE('01/10/21','DD/MM/RR'),TO_DATE('16/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','9','842254',TO_DATE('13/09/21','DD/MM/RR'),TO_DATE('15/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','2','712560',TO_DATE('08/10/21','DD/MM/RR'),TO_DATE('20/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','3','782340',TO_DATE('16/09/21','DD/MM/RR'),TO_DATE('22/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','10','146342',TO_DATE('17/09/21','DD/MM/RR'),TO_DATE('20/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','9','432595',TO_DATE('15/09/21','DD/MM/RR'),TO_DATE('05/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','2','145248',TO_DATE('03/10/21','DD/MM/RR'),TO_DATE('05/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','10','355940',TO_DATE('05/10/21','DD/MM/RR'),TO_DATE('25/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','6','118534',TO_DATE('18/09/21','DD/MM/RR'),TO_DATE('30/10/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','7','848948',TO_DATE('06/10/21','DD/MM/RR'),TO_DATE('30/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','3','876479',TO_DATE('27/09/21','DD/MM/RR'),TO_DATE('23/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','8','827988',TO_DATE('19/09/21','DD/MM/RR'),TO_DATE('04/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','10','357670',TO_DATE('16/09/21','DD/MM/RR'),TO_DATE('04/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','1','114252',TO_DATE('30/09/21','DD/MM/RR'),TO_DATE('25/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','2','686345',TO_DATE('09/10/21','DD/MM/RR'),TO_DATE('08/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','604222',TO_DATE('22/09/21','DD/MM/RR'),TO_DATE('01/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','10','598845',TO_DATE('29/09/21','DD/MM/RR'),TO_DATE('25/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','5','378636',TO_DATE('18/10/21','DD/MM/RR'),TO_DATE('03/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','1','787883',TO_DATE('08/10/21','DD/MM/RR'),TO_DATE('17/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','9','683501',TO_DATE('05/10/21','DD/MM/RR'),TO_DATE('29/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','8','847420',TO_DATE('30/09/21','DD/MM/RR'),TO_DATE('23/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','9','391200',TO_DATE('11/10/21','DD/MM/RR'),TO_DATE('28/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','2','671717',TO_DATE('15/03/21','DD/MM/RR'),TO_DATE('07/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','10','383435',TO_DATE('30/03/21','DD/MM/RR'),TO_DATE('08/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','2','677862',TO_DATE('11/04/21','DD/MM/RR'),TO_DATE('13/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','7','438411',TO_DATE('25/03/21','DD/MM/RR'),TO_DATE('28/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','9','181659',TO_DATE('12/04/21','DD/MM/RR'),TO_DATE('23/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','3','337590',TO_DATE('02/04/21','DD/MM/RR'),TO_DATE('19/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','7','567180',TO_DATE('23/03/21','DD/MM/RR'),TO_DATE('12/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','8','708196',TO_DATE('23/03/21','DD/MM/RR'),TO_DATE('25/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','9','181158',TO_DATE('04/04/21','DD/MM/RR'),TO_DATE('31/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','4','236090',TO_DATE('28/03/21','DD/MM/RR'),TO_DATE('09/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','8','210122',TO_DATE('17/03/21','DD/MM/RR'),TO_DATE('19/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','4','481305',TO_DATE('27/03/21','DD/MM/RR'),TO_DATE('05/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','10','815338',TO_DATE('29/03/21','DD/MM/RR'),TO_DATE('06/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','7','707302',TO_DATE('26/03/21','DD/MM/RR'),TO_DATE('04/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','1','579040',TO_DATE('22/03/21','DD/MM/RR'),TO_DATE('29/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','10','407399',TO_DATE('05/04/21','DD/MM/RR'),TO_DATE('21/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','3','890133',TO_DATE('21/03/21','DD/MM/RR'),TO_DATE('02/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','6','683050',TO_DATE('16/04/21','DD/MM/RR'),TO_DATE('11/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','5','520236',TO_DATE('30/03/21','DD/MM/RR'),TO_DATE('05/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','2','400400',TO_DATE('12/04/21','DD/MM/RR'),TO_DATE('08/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','1','606863',TO_DATE('24/03/21','DD/MM/RR'),TO_DATE('19/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','9','300791',TO_DATE('03/04/21','DD/MM/RR'),TO_DATE('29/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','309659',TO_DATE('19/04/21','DD/MM/RR'),TO_DATE('07/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','2','600906',TO_DATE('14/04/21','DD/MM/RR'),TO_DATE('24/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','3','124229',TO_DATE('26/03/21','DD/MM/RR'),TO_DATE('06/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','7','659407',TO_DATE('24/04/21','DD/MM/RR'),TO_DATE('07/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','9','638735',TO_DATE('28/03/21','DD/MM/RR'),TO_DATE('03/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','2','309249',TO_DATE('01/04/21','DD/MM/RR'),TO_DATE('07/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','9','283008',TO_DATE('08/04/21','DD/MM/RR'),TO_DATE('24/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','1','844092',TO_DATE('21/04/21','DD/MM/RR'),TO_DATE('08/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','1','738823',TO_DATE('22/04/21','DD/MM/RR'),TO_DATE('29/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','3','781045',TO_DATE('24/04/21','DD/MM/RR'),TO_DATE('15/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','8','790515',TO_DATE('17/04/21','DD/MM/RR'),TO_DATE('01/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','6','399081',TO_DATE('25/04/21','DD/MM/RR'),TO_DATE('11/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','4','194072',TO_DATE('14/04/21','DD/MM/RR'),TO_DATE('14/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','5','807840',TO_DATE('19/04/21','DD/MM/RR'),TO_DATE('03/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','10','504259',TO_DATE('07/04/21','DD/MM/RR'),TO_DATE('06/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','9','499147',TO_DATE('27/04/21','DD/MM/RR'),TO_DATE('19/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','5','509296',TO_DATE('13/04/21','DD/MM/RR'),TO_DATE('23/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','2','469896',TO_DATE('10/04/21','DD/MM/RR'),TO_DATE('30/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','5','206351',TO_DATE('26/04/21','DD/MM/RR'),TO_DATE('29/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','8','683591',TO_DATE('15/04/21','DD/MM/RR'),TO_DATE('16/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','5','369731',TO_DATE('11/04/21','DD/MM/RR'),TO_DATE('02/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','3','635959',TO_DATE('27/04/21','DD/MM/RR'),TO_DATE('10/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','8','798458',TO_DATE('05/05/21','DD/MM/RR'),TO_DATE('27/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','8','583282',TO_DATE('04/05/21','DD/MM/RR'),TO_DATE('23/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','4','224574',TO_DATE('23/04/21','DD/MM/RR'),TO_DATE('27/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','2','136543',TO_DATE('09/05/21','DD/MM/RR'),TO_DATE('28/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','3','833890',TO_DATE('15/04/21','DD/MM/RR'),TO_DATE('14/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','5','269506',TO_DATE('11/05/21','DD/MM/RR'),TO_DATE('17/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','2','162936',TO_DATE('20/04/21','DD/MM/RR'),TO_DATE('17/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','3','584103',TO_DATE('28/04/21','DD/MM/RR'),TO_DATE('07/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','4','632835',TO_DATE('21/04/21','DD/MM/RR'),TO_DATE('18/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','5','779737',TO_DATE('30/04/21','DD/MM/RR'),TO_DATE('22/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','3','310562',TO_DATE('17/04/21','DD/MM/RR'),TO_DATE('22/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','3','323904',TO_DATE('23/04/21','DD/MM/RR'),TO_DATE('14/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','9','571318',TO_DATE('03/05/21','DD/MM/RR'),TO_DATE('23/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','4','850291',TO_DATE('15/05/21','DD/MM/RR'),TO_DATE('17/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','6','237697',TO_DATE('11/05/21','DD/MM/RR'),TO_DATE('01/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','10','223132',TO_DATE('10/05/21','DD/MM/RR'),TO_DATE('26/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','8','164912',TO_DATE('26/04/21','DD/MM/RR'),TO_DATE('06/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','10','202366',TO_DATE('16/05/21','DD/MM/RR'),TO_DATE('09/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','7','532865',TO_DATE('03/05/21','DD/MM/RR'),TO_DATE('02/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','5','102925',TO_DATE('21/05/21','DD/MM/RR'),TO_DATE('20/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','10','761862',TO_DATE('25/04/21','DD/MM/RR'),TO_DATE('23/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','9','462347',TO_DATE('05/05/21','DD/MM/RR'),TO_DATE('19/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','8','356445',TO_DATE('01/05/21','DD/MM/RR'),TO_DATE('07/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','3','324238',TO_DATE('02/05/21','DD/MM/RR'),TO_DATE('05/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','2','636411',TO_DATE('07/05/21','DD/MM/RR'),TO_DATE('14/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','4','731558',TO_DATE('08/05/21','DD/MM/RR'),TO_DATE('18/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','1','513304',TO_DATE('15/05/21','DD/MM/RR'),TO_DATE('21/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','9','163610',TO_DATE('06/05/21','DD/MM/RR'),TO_DATE('20/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','10','723139',TO_DATE('30/04/21','DD/MM/RR'),TO_DATE('25/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','3','524024',TO_DATE('13/05/21','DD/MM/RR'),TO_DATE('27/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','1','648344',TO_DATE('08/05/21','DD/MM/RR'),TO_DATE('01/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','1','442947',TO_DATE('18/05/21','DD/MM/RR'),TO_DATE('22/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','1','639295',TO_DATE('29/04/21','DD/MM/RR'),TO_DATE('06/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','5','180880',TO_DATE('17/05/21','DD/MM/RR'),TO_DATE('09/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','3','276050',TO_DATE('06/05/21','DD/MM/RR'),TO_DATE('23/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','3','766960',TO_DATE('14/05/21','DD/MM/RR'),TO_DATE('22/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','10','448653',TO_DATE('24/05/21','DD/MM/RR'),TO_DATE('14/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','1','537801',TO_DATE('12/05/21','DD/MM/RR'),TO_DATE('29/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','632663',TO_DATE('18/05/21','DD/MM/RR'),TO_DATE('09/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','2','806142',TO_DATE('22/05/21','DD/MM/RR'),TO_DATE('04/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','9','334334',TO_DATE('29/04/21','DD/MM/RR'),TO_DATE('26/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','8','639350',TO_DATE('14/05/21','DD/MM/RR'),TO_DATE('14/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','4','326562',TO_DATE('16/05/21','DD/MM/RR'),TO_DATE('02/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','4','453981',TO_DATE('28/05/21','DD/MM/RR'),TO_DATE('28/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','4','421311',TO_DATE('30/05/21','DD/MM/RR'),TO_DATE('10/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','7','824742',TO_DATE('10/05/21','DD/MM/RR'),TO_DATE('24/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','5','450707',TO_DATE('19/05/21','DD/MM/RR'),TO_DATE('30/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','870991',TO_DATE('02/05/21','DD/MM/RR'),TO_DATE('10/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','2','794518',TO_DATE('25/05/21','DD/MM/RR'),TO_DATE('04/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','5','810260',TO_DATE('20/05/21','DD/MM/RR'),TO_DATE('30/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','6','142513',TO_DATE('31/05/21','DD/MM/RR'),TO_DATE('10/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','3','723779',TO_DATE('29/05/21','DD/MM/RR'),TO_DATE('26/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','5','892923',TO_DATE('02/06/21','DD/MM/RR'),TO_DATE('21/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','9','555539',TO_DATE('09/05/21','DD/MM/RR'),TO_DATE('29/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','1','600952',TO_DATE('07/05/21','DD/MM/RR'),TO_DATE('27/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','7','780723',TO_DATE('22/05/21','DD/MM/RR'),TO_DATE('16/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','1','314494',TO_DATE('12/05/21','DD/MM/RR'),TO_DATE('11/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','4','246036',TO_DATE('21/05/21','DD/MM/RR'),TO_DATE('23/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','8','448352',TO_DATE('07/06/21','DD/MM/RR'),TO_DATE('21/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','1','672433',TO_DATE('01/06/21','DD/MM/RR'),TO_DATE('01/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','1','694754',TO_DATE('27/05/21','DD/MM/RR'),TO_DATE('01/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','4','411768',TO_DATE('29/05/21','DD/MM/RR'),TO_DATE('20/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','4','747461',TO_DATE('17/05/21','DD/MM/RR'),TO_DATE('11/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','4','163623',TO_DATE('13/05/21','DD/MM/RR'),TO_DATE('05/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','3','439940',TO_DATE('27/05/21','DD/MM/RR'),TO_DATE('06/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','3','333807',TO_DATE('09/06/21','DD/MM/RR'),TO_DATE('15/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','10','332198',TO_DATE('23/05/21','DD/MM/RR'),TO_DATE('14/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','6','456164',TO_DATE('06/06/21','DD/MM/RR'),TO_DATE('18/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','1','417941',TO_DATE('05/06/21','DD/MM/RR'),TO_DATE('22/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','5','668450',TO_DATE('23/05/21','DD/MM/RR'),TO_DATE('14/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','7','652510',TO_DATE('30/05/21','DD/MM/RR'),TO_DATE('23/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','1','202081',TO_DATE('31/05/21','DD/MM/RR'),TO_DATE('06/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','1','198469',TO_DATE('08/06/21','DD/MM/RR'),TO_DATE('15/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','4','376731',TO_DATE('24/05/21','DD/MM/RR'),TO_DATE('05/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','6','723459',TO_DATE('04/06/21','DD/MM/RR'),TO_DATE('12/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','6','184475',TO_DATE('11/06/21','DD/MM/RR'),TO_DATE('17/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','3','103415',TO_DATE('02/01/19','DD/MM/RR'),TO_DATE('14/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','5','872093',TO_DATE('04/01/19','DD/MM/RR'),TO_DATE('08/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','1','687846',TO_DATE('06/01/19','DD/MM/RR'),TO_DATE('04/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','4','552461',TO_DATE('08/01/19','DD/MM/RR'),TO_DATE('01/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','2','167721',TO_DATE('10/01/19','DD/MM/RR'),TO_DATE('11/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','3','231098',TO_DATE('12/01/19','DD/MM/RR'),TO_DATE('04/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','7','749303',TO_DATE('14/01/19','DD/MM/RR'),TO_DATE('05/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','8','165717',TO_DATE('16/01/19','DD/MM/RR'),TO_DATE('05/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','3','443924',TO_DATE('18/01/19','DD/MM/RR'),TO_DATE('22/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','4','268353',TO_DATE('20/01/19','DD/MM/RR'),TO_DATE('11/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','3','278976',TO_DATE('22/01/19','DD/MM/RR'),TO_DATE('12/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','6','493630',TO_DATE('24/01/19','DD/MM/RR'),TO_DATE('22/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','6','227649',TO_DATE('26/01/19','DD/MM/RR'),TO_DATE('30/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','3','787352',TO_DATE('28/01/19','DD/MM/RR'),TO_DATE('16/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','10','563981',TO_DATE('30/01/19','DD/MM/RR'),TO_DATE('25/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','1','830208',TO_DATE('01/02/19','DD/MM/RR'),TO_DATE('03/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','410779',TO_DATE('03/02/19','DD/MM/RR'),TO_DATE('27/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','8','452048',TO_DATE('05/02/19','DD/MM/RR'),TO_DATE('13/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','9','162683',TO_DATE('07/02/19','DD/MM/RR'),TO_DATE('08/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','10','252769',TO_DATE('09/02/19','DD/MM/RR'),TO_DATE('15/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','3','802218',TO_DATE('11/02/19','DD/MM/RR'),TO_DATE('30/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','4','520941',TO_DATE('13/02/19','DD/MM/RR'),TO_DATE('06/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','8','892695',TO_DATE('15/02/19','DD/MM/RR'),TO_DATE('16/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','8','566837',TO_DATE('17/02/19','DD/MM/RR'),TO_DATE('19/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','10','818652',TO_DATE('19/02/19','DD/MM/RR'),TO_DATE('09/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','4','588785',TO_DATE('21/02/19','DD/MM/RR'),TO_DATE('20/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','5','488016',TO_DATE('23/02/19','DD/MM/RR'),TO_DATE('18/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','5','329921',TO_DATE('25/02/19','DD/MM/RR'),TO_DATE('03/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','5','716795',TO_DATE('27/02/19','DD/MM/RR'),TO_DATE('26/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','8','292641',TO_DATE('01/03/19','DD/MM/RR'),TO_DATE('30/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','7','274213',TO_DATE('03/03/19','DD/MM/RR'),TO_DATE('20/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','2','667328',TO_DATE('05/03/19','DD/MM/RR'),TO_DATE('08/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','1','208428',TO_DATE('07/03/19','DD/MM/RR'),TO_DATE('05/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','1','846791',TO_DATE('09/03/19','DD/MM/RR'),TO_DATE('07/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','9','694903',TO_DATE('11/03/19','DD/MM/RR'),TO_DATE('02/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','10','185648',TO_DATE('13/03/19','DD/MM/RR'),TO_DATE('13/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','9','869715',TO_DATE('15/03/19','DD/MM/RR'),TO_DATE('23/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','1','482895',TO_DATE('17/03/19','DD/MM/RR'),TO_DATE('23/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','1','662892',TO_DATE('19/03/19','DD/MM/RR'),TO_DATE('11/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','9','263783',TO_DATE('21/03/19','DD/MM/RR'),TO_DATE('07/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','9','899843',TO_DATE('23/03/19','DD/MM/RR'),TO_DATE('26/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','7','105093',TO_DATE('25/03/19','DD/MM/RR'),TO_DATE('12/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','3','169723',TO_DATE('27/03/19','DD/MM/RR'),TO_DATE('19/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','4','583967',TO_DATE('29/03/19','DD/MM/RR'),TO_DATE('05/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','4','802802',TO_DATE('31/03/19','DD/MM/RR'),TO_DATE('29/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','6','681449',TO_DATE('02/04/19','DD/MM/RR'),TO_DATE('22/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','4','574091',TO_DATE('04/04/19','DD/MM/RR'),TO_DATE('21/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','6','634586',TO_DATE('06/04/19','DD/MM/RR'),TO_DATE('22/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','8','582235',TO_DATE('08/04/19','DD/MM/RR'),TO_DATE('31/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','9','545965',TO_DATE('10/04/19','DD/MM/RR'),TO_DATE('21/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','8','434737',TO_DATE('12/04/19','DD/MM/RR'),TO_DATE('16/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','5','823368',TO_DATE('14/04/19','DD/MM/RR'),TO_DATE('06/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','4','717910',TO_DATE('16/04/19','DD/MM/RR'),TO_DATE('27/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','4','773399',TO_DATE('18/04/19','DD/MM/RR'),TO_DATE('19/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','2','141019',TO_DATE('20/04/19','DD/MM/RR'),TO_DATE('17/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','5','729312',TO_DATE('22/04/19','DD/MM/RR'),TO_DATE('25/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','5','512564',TO_DATE('24/04/19','DD/MM/RR'),TO_DATE('11/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','6','698144',TO_DATE('26/04/19','DD/MM/RR'),TO_DATE('18/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','2','609593',TO_DATE('28/04/19','DD/MM/RR'),TO_DATE('28/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','6','173257',TO_DATE('30/04/19','DD/MM/RR'),TO_DATE('17/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','8','219174',TO_DATE('02/05/19','DD/MM/RR'),TO_DATE('24/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','3','328525',TO_DATE('04/05/19','DD/MM/RR'),TO_DATE('10/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','2','848944',TO_DATE('06/05/19','DD/MM/RR'),TO_DATE('12/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','3','568402',TO_DATE('08/05/19','DD/MM/RR'),TO_DATE('16/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','4','193975',TO_DATE('10/05/19','DD/MM/RR'),TO_DATE('08/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','7','412947',TO_DATE('12/05/19','DD/MM/RR'),TO_DATE('27/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','10','628602',TO_DATE('14/05/19','DD/MM/RR'),TO_DATE('25/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','8','501630',TO_DATE('16/05/19','DD/MM/RR'),TO_DATE('03/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','6','302145',TO_DATE('18/05/19','DD/MM/RR'),TO_DATE('03/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','9','472355',TO_DATE('20/05/19','DD/MM/RR'),TO_DATE('07/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','5','735915',TO_DATE('22/05/19','DD/MM/RR'),TO_DATE('10/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','9','754667',TO_DATE('24/05/19','DD/MM/RR'),TO_DATE('12/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','1','518677',TO_DATE('26/05/19','DD/MM/RR'),TO_DATE('22/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','1','602036',TO_DATE('28/05/19','DD/MM/RR'),TO_DATE('17/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','6','622979',TO_DATE('30/05/19','DD/MM/RR'),TO_DATE('23/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','9','374193',TO_DATE('01/06/19','DD/MM/RR'),TO_DATE('23/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','5','593154',TO_DATE('03/06/19','DD/MM/RR'),TO_DATE('23/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','10','376461',TO_DATE('05/06/19','DD/MM/RR'),TO_DATE('20/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','7','133469',TO_DATE('07/06/19','DD/MM/RR'),TO_DATE('09/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','116315',TO_DATE('09/06/19','DD/MM/RR'),TO_DATE('06/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','1','204126',TO_DATE('11/06/19','DD/MM/RR'),TO_DATE('26/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','10','528744',TO_DATE('13/06/19','DD/MM/RR'),TO_DATE('05/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','1','553838',TO_DATE('15/06/19','DD/MM/RR'),TO_DATE('11/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','6','708351',TO_DATE('17/06/19','DD/MM/RR'),TO_DATE('02/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','5','592882',TO_DATE('19/06/19','DD/MM/RR'),TO_DATE('05/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','10','577121',TO_DATE('21/06/19','DD/MM/RR'),TO_DATE('17/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','8','290136',TO_DATE('23/06/19','DD/MM/RR'),TO_DATE('28/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','884373',TO_DATE('25/06/19','DD/MM/RR'),TO_DATE('14/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','8','224188',TO_DATE('27/06/19','DD/MM/RR'),TO_DATE('10/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','4','140121',TO_DATE('29/06/19','DD/MM/RR'),TO_DATE('26/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','229606',TO_DATE('01/07/19','DD/MM/RR'),TO_DATE('19/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','10','337529',TO_DATE('03/07/19','DD/MM/RR'),TO_DATE('14/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','1','354700',TO_DATE('05/07/19','DD/MM/RR'),TO_DATE('28/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','7','462317',TO_DATE('07/07/19','DD/MM/RR'),TO_DATE('15/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','6','444617',TO_DATE('09/07/19','DD/MM/RR'),TO_DATE('27/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','10','784503',TO_DATE('11/07/19','DD/MM/RR'),TO_DATE('19/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','7','241869',TO_DATE('13/07/19','DD/MM/RR'),TO_DATE('27/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','4','394675',TO_DATE('15/07/19','DD/MM/RR'),TO_DATE('18/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','8','374097',TO_DATE('17/07/19','DD/MM/RR'),TO_DATE('29/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','9','888845',TO_DATE('19/07/19','DD/MM/RR'),TO_DATE('24/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','9','572339',TO_DATE('21/07/19','DD/MM/RR'),TO_DATE('15/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','6','579942',TO_DATE('23/07/19','DD/MM/RR'),TO_DATE('10/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','1','820672',TO_DATE('25/07/19','DD/MM/RR'),TO_DATE('13/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','8','253271',TO_DATE('27/07/19','DD/MM/RR'),TO_DATE('17/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','9','436228',TO_DATE('29/07/19','DD/MM/RR'),TO_DATE('24/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','8','622160',TO_DATE('31/07/19','DD/MM/RR'),TO_DATE('05/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','8','485830',TO_DATE('02/08/19','DD/MM/RR'),TO_DATE('10/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','5','802348',TO_DATE('04/08/19','DD/MM/RR'),TO_DATE('20/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','9','411350',TO_DATE('06/08/19','DD/MM/RR'),TO_DATE('26/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','10','590054',TO_DATE('08/08/19','DD/MM/RR'),TO_DATE('24/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','1','453536',TO_DATE('10/08/19','DD/MM/RR'),TO_DATE('25/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','8','830324',TO_DATE('12/08/19','DD/MM/RR'),TO_DATE('23/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','6','214721',TO_DATE('14/08/19','DD/MM/RR'),TO_DATE('26/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','3','126638',TO_DATE('16/08/19','DD/MM/RR'),TO_DATE('20/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','8','547319',TO_DATE('18/08/19','DD/MM/RR'),TO_DATE('03/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','1','620927',TO_DATE('20/08/19','DD/MM/RR'),TO_DATE('11/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','10','143356',TO_DATE('22/08/19','DD/MM/RR'),TO_DATE('20/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','4','821874',TO_DATE('24/08/19','DD/MM/RR'),TO_DATE('06/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','2','142263',TO_DATE('26/08/19','DD/MM/RR'),TO_DATE('11/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','6','263626',TO_DATE('28/08/19','DD/MM/RR'),TO_DATE('13/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','6','229361',TO_DATE('30/08/19','DD/MM/RR'),TO_DATE('07/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','2','330668',TO_DATE('01/09/19','DD/MM/RR'),TO_DATE('11/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','6','525135',TO_DATE('03/09/19','DD/MM/RR'),TO_DATE('04/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','4','404012',TO_DATE('05/09/19','DD/MM/RR'),TO_DATE('05/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','9','623905',TO_DATE('07/09/19','DD/MM/RR'),TO_DATE('06/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','5','698085',TO_DATE('09/09/19','DD/MM/RR'),TO_DATE('01/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','8','207450',TO_DATE('11/09/19','DD/MM/RR'),TO_DATE('16/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','8','843346',TO_DATE('13/09/19','DD/MM/RR'),TO_DATE('20/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','3','198990',TO_DATE('15/09/19','DD/MM/RR'),TO_DATE('02/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','5','884293',TO_DATE('17/09/19','DD/MM/RR'),TO_DATE('07/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','7','565376',TO_DATE('19/09/19','DD/MM/RR'),TO_DATE('03/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','3','757344',TO_DATE('21/09/19','DD/MM/RR'),TO_DATE('08/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','1','384432',TO_DATE('23/09/19','DD/MM/RR'),TO_DATE('01/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','5','702970',TO_DATE('25/09/19','DD/MM/RR'),TO_DATE('27/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','5','864825',TO_DATE('27/09/19','DD/MM/RR'),TO_DATE('20/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','6','592913',TO_DATE('29/09/19','DD/MM/RR'),TO_DATE('15/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','9','879723',TO_DATE('01/10/19','DD/MM/RR'),TO_DATE('21/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','9','483589',TO_DATE('03/10/19','DD/MM/RR'),TO_DATE('12/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','7','638428',TO_DATE('05/10/19','DD/MM/RR'),TO_DATE('30/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','8','835217',TO_DATE('07/10/19','DD/MM/RR'),TO_DATE('25/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','7','504599',TO_DATE('09/10/19','DD/MM/RR'),TO_DATE('03/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','3','727140',TO_DATE('11/10/19','DD/MM/RR'),TO_DATE('31/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','4','802055',TO_DATE('13/10/19','DD/MM/RR'),TO_DATE('18/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','8','243015',TO_DATE('15/10/19','DD/MM/RR'),TO_DATE('03/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','7','152055',TO_DATE('17/10/19','DD/MM/RR'),TO_DATE('05/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','8','894222',TO_DATE('19/10/19','DD/MM/RR'),TO_DATE('03/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','4','511118',TO_DATE('21/10/19','DD/MM/RR'),TO_DATE('19/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','8','585145',TO_DATE('23/10/19','DD/MM/RR'),TO_DATE('01/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','6','630034',TO_DATE('25/10/19','DD/MM/RR'),TO_DATE('02/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','7','139031',TO_DATE('27/10/19','DD/MM/RR'),TO_DATE('12/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','10','677186',TO_DATE('29/10/19','DD/MM/RR'),TO_DATE('31/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','4','647470',TO_DATE('31/10/19','DD/MM/RR'),TO_DATE('23/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','6','176993',TO_DATE('02/11/19','DD/MM/RR'),TO_DATE('28/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','10','889681',TO_DATE('04/11/19','DD/MM/RR'),TO_DATE('14/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','1','777717',TO_DATE('06/11/19','DD/MM/RR'),TO_DATE('31/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','4','414956',TO_DATE('08/11/19','DD/MM/RR'),TO_DATE('27/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','4','754970',TO_DATE('10/11/19','DD/MM/RR'),TO_DATE('06/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','7','712683',TO_DATE('12/11/19','DD/MM/RR'),TO_DATE('07/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','10','591593',TO_DATE('14/11/19','DD/MM/RR'),TO_DATE('13/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','9','246825',TO_DATE('16/11/19','DD/MM/RR'),TO_DATE('31/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','1','881782',TO_DATE('18/11/19','DD/MM/RR'),TO_DATE('11/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','9','201396',TO_DATE('20/11/19','DD/MM/RR'),TO_DATE('18/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','8','243737',TO_DATE('22/11/19','DD/MM/RR'),TO_DATE('18/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','2','895245',TO_DATE('24/11/19','DD/MM/RR'),TO_DATE('03/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','10','558030',TO_DATE('26/11/19','DD/MM/RR'),TO_DATE('22/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','1','200434',TO_DATE('28/11/19','DD/MM/RR'),TO_DATE('20/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','10','554901',TO_DATE('30/11/19','DD/MM/RR'),TO_DATE('09/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','7','779139',TO_DATE('02/12/19','DD/MM/RR'),TO_DATE('31/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','1','473269',TO_DATE('04/12/19','DD/MM/RR'),TO_DATE('07/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','5','640331',TO_DATE('06/12/19','DD/MM/RR'),TO_DATE('06/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','3','536266',TO_DATE('08/12/19','DD/MM/RR'),TO_DATE('01/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','3','342517',TO_DATE('10/12/19','DD/MM/RR'),TO_DATE('11/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','2','504249',TO_DATE('12/12/19','DD/MM/RR'),TO_DATE('29/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','10','367123',TO_DATE('14/12/19','DD/MM/RR'),TO_DATE('28/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','1','731588',TO_DATE('16/12/19','DD/MM/RR'),TO_DATE('13/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','3','420477',TO_DATE('18/12/19','DD/MM/RR'),TO_DATE('28/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','4','718451',TO_DATE('20/12/19','DD/MM/RR'),TO_DATE('11/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','3','649412',TO_DATE('22/12/19','DD/MM/RR'),TO_DATE('07/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','6','802594',TO_DATE('24/12/19','DD/MM/RR'),TO_DATE('15/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','8','333034',TO_DATE('26/12/19','DD/MM/RR'),TO_DATE('17/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','1','239225',TO_DATE('28/12/19','DD/MM/RR'),TO_DATE('13/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','6','247308',TO_DATE('30/12/19','DD/MM/RR'),TO_DATE('07/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','9','212455',TO_DATE('03/01/19','DD/MM/RR'),TO_DATE('10/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','6','167244',TO_DATE('05/01/19','DD/MM/RR'),TO_DATE('15/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','6','364952',TO_DATE('07/01/19','DD/MM/RR'),TO_DATE('28/02/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','1','871051',TO_DATE('09/01/19','DD/MM/RR'),TO_DATE('03/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','9','727390',TO_DATE('11/01/19','DD/MM/RR'),TO_DATE('09/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','9','743868',TO_DATE('13/01/19','DD/MM/RR'),TO_DATE('10/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','4','382059',TO_DATE('15/01/19','DD/MM/RR'),TO_DATE('17/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','8','733931',TO_DATE('17/01/19','DD/MM/RR'),TO_DATE('27/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','10','885763',TO_DATE('19/01/19','DD/MM/RR'),TO_DATE('05/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','9','668873',TO_DATE('21/01/19','DD/MM/RR'),TO_DATE('03/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','5','175737',TO_DATE('23/01/19','DD/MM/RR'),TO_DATE('15/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','9','485410',TO_DATE('25/01/19','DD/MM/RR'),TO_DATE('13/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','10','424348',TO_DATE('27/01/19','DD/MM/RR'),TO_DATE('22/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','6','838643',TO_DATE('29/01/19','DD/MM/RR'),TO_DATE('14/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','2','318878',TO_DATE('31/01/19','DD/MM/RR'),TO_DATE('07/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','1','230329',TO_DATE('02/02/19','DD/MM/RR'),TO_DATE('29/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','2','230511',TO_DATE('04/02/19','DD/MM/RR'),TO_DATE('25/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','8','617764',TO_DATE('06/02/19','DD/MM/RR'),TO_DATE('13/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','9','266758',TO_DATE('08/02/19','DD/MM/RR'),TO_DATE('09/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','10','496801',TO_DATE('10/02/19','DD/MM/RR'),TO_DATE('26/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','8','602920',TO_DATE('12/02/19','DD/MM/RR'),TO_DATE('08/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','9','715009',TO_DATE('14/02/19','DD/MM/RR'),TO_DATE('31/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','1','485532',TO_DATE('16/02/19','DD/MM/RR'),TO_DATE('02/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','10','186827',TO_DATE('18/02/19','DD/MM/RR'),TO_DATE('08/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','7','511667',TO_DATE('20/02/19','DD/MM/RR'),TO_DATE('06/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','8','466598',TO_DATE('08/09/19','DD/MM/RR'),TO_DATE('16/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','6','859626',TO_DATE('20/08/19','DD/MM/RR'),TO_DATE('18/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','9','448871',TO_DATE('09/09/19','DD/MM/RR'),TO_DATE('19/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','4','763986',TO_DATE('17/08/19','DD/MM/RR'),TO_DATE('27/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','3','413686',TO_DATE('19/08/19','DD/MM/RR'),TO_DATE('02/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','10','591480',TO_DATE('14/09/19','DD/MM/RR'),TO_DATE('10/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','9','846015',TO_DATE('25/08/19','DD/MM/RR'),TO_DATE('20/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','6','849877',TO_DATE('26/08/19','DD/MM/RR'),TO_DATE('19/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','2','130409',TO_DATE('30/08/19','DD/MM/RR'),TO_DATE('03/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','7','548080',TO_DATE('07/09/19','DD/MM/RR'),TO_DATE('17/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','5','399455',TO_DATE('31/08/19','DD/MM/RR'),TO_DATE('05/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','9','700958',TO_DATE('28/08/19','DD/MM/RR'),TO_DATE('23/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','2','232082',TO_DATE('03/09/19','DD/MM/RR'),TO_DATE('11/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','8','240267',TO_DATE('29/08/19','DD/MM/RR'),TO_DATE('07/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','4','236327',TO_DATE('16/09/19','DD/MM/RR'),TO_DATE('17/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','6','798083',TO_DATE('01/09/19','DD/MM/RR'),TO_DATE('07/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','2','138780',TO_DATE('22/09/19','DD/MM/RR'),TO_DATE('16/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','2','495057',TO_DATE('06/09/19','DD/MM/RR'),TO_DATE('14/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','1','669779',TO_DATE('11/09/19','DD/MM/RR'),TO_DATE('01/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','2','139832',TO_DATE('13/09/19','DD/MM/RR'),TO_DATE('23/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','4','564560',TO_DATE('04/09/19','DD/MM/RR'),TO_DATE('03/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','1','500105',TO_DATE('19/09/19','DD/MM/RR'),TO_DATE('01/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','7','573215',TO_DATE('21/09/19','DD/MM/RR'),TO_DATE('27/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','2','705397',TO_DATE('29/09/19','DD/MM/RR'),TO_DATE('30/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','7','562082',TO_DATE('24/09/19','DD/MM/RR'),TO_DATE('31/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','3','880944',TO_DATE('30/09/19','DD/MM/RR'),TO_DATE('31/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','1','109970',TO_DATE('12/09/19','DD/MM/RR'),TO_DATE('22/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','9','344408',TO_DATE('10/09/19','DD/MM/RR'),TO_DATE('29/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','4','840430',TO_DATE('15/09/19','DD/MM/RR'),TO_DATE('10/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','4','253635',TO_DATE('03/10/19','DD/MM/RR'),TO_DATE('15/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','2','107193',TO_DATE('13/09/19','DD/MM/RR'),TO_DATE('12/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','6','147508',TO_DATE('08/10/19','DD/MM/RR'),TO_DATE('23/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','2','511832',TO_DATE('25/09/19','DD/MM/RR'),TO_DATE('28/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','10','118612',TO_DATE('20/09/19','DD/MM/RR'),TO_DATE('07/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','6','687989',TO_DATE('28/09/19','DD/MM/RR'),TO_DATE('20/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','2','871455',TO_DATE('07/10/19','DD/MM/RR'),TO_DATE('26/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','2','544639',TO_DATE('18/09/19','DD/MM/RR'),TO_DATE('31/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','1','876238',TO_DATE('27/09/19','DD/MM/RR'),TO_DATE('06/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','3','681990',TO_DATE('26/09/19','DD/MM/RR'),TO_DATE('21/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','2','686772',TO_DATE('21/09/19','DD/MM/RR'),TO_DATE('09/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','1','274986',TO_DATE('08/10/19','DD/MM/RR'),TO_DATE('13/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','8','400901',TO_DATE('02/10/19','DD/MM/RR'),TO_DATE('04/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','2','543946',TO_DATE('20/10/19','DD/MM/RR'),TO_DATE('13/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','2','696413',TO_DATE('05/10/19','DD/MM/RR'),TO_DATE('30/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','4','630440',TO_DATE('15/10/19','DD/MM/RR'),TO_DATE('27/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','8','235099',TO_DATE('12/10/19','DD/MM/RR'),TO_DATE('16/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','7','268357',TO_DATE('13/10/19','DD/MM/RR'),TO_DATE('07/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','9','427359',TO_DATE('22/10/19','DD/MM/RR'),TO_DATE('01/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','2','370275',TO_DATE('06/10/19','DD/MM/RR'),TO_DATE('02/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','5','451917',TO_DATE('11/10/19','DD/MM/RR'),TO_DATE('15/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','3','823837',TO_DATE('14/10/19','DD/MM/RR'),TO_DATE('29/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','9','201002',TO_DATE('23/10/19','DD/MM/RR'),TO_DATE('22/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','3','237760',TO_DATE('01/10/19','DD/MM/RR'),TO_DATE('05/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','2','760278',TO_DATE('26/10/19','DD/MM/RR'),TO_DATE('10/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','9','442844',TO_DATE('21/10/19','DD/MM/RR'),TO_DATE('18/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','9','394177',TO_DATE('11/10/19','DD/MM/RR'),TO_DATE('17/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','7','892339',TO_DATE('05/10/19','DD/MM/RR'),TO_DATE('12/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','9','119758',TO_DATE('26/10/19','DD/MM/RR'),TO_DATE('09/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','4','485520',TO_DATE('24/10/19','DD/MM/RR'),TO_DATE('20/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','6','675267',TO_DATE('17/10/19','DD/MM/RR'),TO_DATE('08/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','273611',TO_DATE('06/11/19','DD/MM/RR'),TO_DATE('24/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','2','751260',TO_DATE('01/11/19','DD/MM/RR'),TO_DATE('11/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','1','120079',TO_DATE('19/10/19','DD/MM/RR'),TO_DATE('18/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','2','269203',TO_DATE('03/11/19','DD/MM/RR'),TO_DATE('18/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','2','320309',TO_DATE('23/10/19','DD/MM/RR'),TO_DATE('11/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','5','497484',TO_DATE('08/11/19','DD/MM/RR'),TO_DATE('18/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','4','693103',TO_DATE('29/10/19','DD/MM/RR'),TO_DATE('20/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','2','814262',TO_DATE('16/10/19','DD/MM/RR'),TO_DATE('30/11/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','2','688938',TO_DATE('18/10/19','DD/MM/RR'),TO_DATE('09/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','6','719563',TO_DATE('26/10/19','DD/MM/RR'),TO_DATE('06/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','8','485883',TO_DATE('30/10/19','DD/MM/RR'),TO_DATE('10/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','3','223849',TO_DATE('16/11/19','DD/MM/RR'),TO_DATE('30/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','4','264523',TO_DATE('07/11/19','DD/MM/RR'),TO_DATE('21/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','9','661657',TO_DATE('12/11/19','DD/MM/RR'),TO_DATE('24/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','4','108887',TO_DATE('02/11/19','DD/MM/RR'),TO_DATE('19/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','6','600305',TO_DATE('21/11/19','DD/MM/RR'),TO_DATE('09/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','2','493921',TO_DATE('31/10/19','DD/MM/RR'),TO_DATE('16/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','9','854935',TO_DATE('18/11/19','DD/MM/RR'),TO_DATE('27/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','6','686963',TO_DATE('11/11/19','DD/MM/RR'),TO_DATE('05/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','9','732932',TO_DATE('14/11/19','DD/MM/RR'),TO_DATE('26/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','395128',TO_DATE('20/11/19','DD/MM/RR'),TO_DATE('03/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','5','644706',TO_DATE('05/11/19','DD/MM/RR'),TO_DATE('16/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','170314',TO_DATE('26/11/19','DD/MM/RR'),TO_DATE('19/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','9','556518',TO_DATE('15/11/19','DD/MM/RR'),TO_DATE('14/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','10','334720',TO_DATE('06/11/19','DD/MM/RR'),TO_DATE('16/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','4','897303',TO_DATE('29/11/19','DD/MM/RR'),TO_DATE('05/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','4','207618',TO_DATE('02/12/19','DD/MM/RR'),TO_DATE('07/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','10','253585',TO_DATE('10/11/19','DD/MM/RR'),TO_DATE('03/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','2','519029',TO_DATE('05/12/19','DD/MM/RR'),TO_DATE('12/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','3','295585',TO_DATE('28/11/19','DD/MM/RR'),TO_DATE('20/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','6','283436',TO_DATE('09/11/19','DD/MM/RR'),TO_DATE('14/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','4','400374',TO_DATE('02/12/19','DD/MM/RR'),TO_DATE('13/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','8','104099',TO_DATE('07/12/19','DD/MM/RR'),TO_DATE('21/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','6','516901',TO_DATE('14/11/19','DD/MM/RR'),TO_DATE('16/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','10','344143',TO_DATE('17/11/19','DD/MM/RR'),TO_DATE('10/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','150934',TO_DATE('12/12/19','DD/MM/RR'),TO_DATE('08/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','2','732382',TO_DATE('24/11/19','DD/MM/RR'),TO_DATE('09/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','1','443619',TO_DATE('24/11/19','DD/MM/RR'),TO_DATE('08/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','1','409983',TO_DATE('30/11/19','DD/MM/RR'),TO_DATE('13/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','3','489464',TO_DATE('17/12/19','DD/MM/RR'),TO_DATE('19/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','7','133504',TO_DATE('22/11/19','DD/MM/RR'),TO_DATE('24/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','5','844836',TO_DATE('19/11/19','DD/MM/RR'),TO_DATE('20/12/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','10','478544',TO_DATE('23/11/19','DD/MM/RR'),TO_DATE('03/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','3','667455',TO_DATE('16/12/19','DD/MM/RR'),TO_DATE('28/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','6','322591',TO_DATE('21/12/19','DD/MM/RR'),TO_DATE('23/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','4','298398',TO_DATE('25/11/19','DD/MM/RR'),TO_DATE('21/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','6','531050',TO_DATE('07/12/19','DD/MM/RR'),TO_DATE('28/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','10','218225',TO_DATE('03/12/19','DD/MM/RR'),TO_DATE('13/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','1','175436',TO_DATE('18/12/19','DD/MM/RR'),TO_DATE('05/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','1','620415',TO_DATE('08/12/19','DD/MM/RR'),TO_DATE('07/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','8','159343',TO_DATE('16/12/19','DD/MM/RR'),TO_DATE('23/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','2','655039',TO_DATE('26/12/19','DD/MM/RR'),TO_DATE('13/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','4','126483',TO_DATE('10/12/19','DD/MM/RR'),TO_DATE('27/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','5','623516',TO_DATE('11/12/19','DD/MM/RR'),TO_DATE('25/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','3','634266',TO_DATE('24/12/19','DD/MM/RR'),TO_DATE('21/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','6','634668',TO_DATE('28/12/19','DD/MM/RR'),TO_DATE('02/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','2','800703',TO_DATE('05/12/19','DD/MM/RR'),TO_DATE('25/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','10','745766',TO_DATE('09/12/19','DD/MM/RR'),TO_DATE('20/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','3','756332',TO_DATE('04/01/20','DD/MM/RR'),TO_DATE('28/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','5','769237',TO_DATE('30/12/19','DD/MM/RR'),TO_DATE('24/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','9','894542',TO_DATE('21/12/19','DD/MM/RR'),TO_DATE('07/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','3','692191',TO_DATE('14/12/19','DD/MM/RR'),TO_DATE('04/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','6','812599',TO_DATE('09/01/20','DD/MM/RR'),TO_DATE('01/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','3','321738',TO_DATE('07/01/20','DD/MM/RR'),TO_DATE('17/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','8','643408',TO_DATE('14/12/19','DD/MM/RR'),TO_DATE('17/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','7','897872',TO_DATE('02/01/20','DD/MM/RR'),TO_DATE('03/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','3','830290',TO_DATE('19/12/19','DD/MM/RR'),TO_DATE('25/01/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','2','436973',TO_DATE('26/12/19','DD/MM/RR'),TO_DATE('21/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','8','744865',TO_DATE('14/01/20','DD/MM/RR'),TO_DATE('26/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','7','394311',TO_DATE('28/12/19','DD/MM/RR'),TO_DATE('10/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','4','713705',TO_DATE('03/01/20','DD/MM/RR'),TO_DATE('06/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','3','310979',TO_DATE('11/01/20','DD/MM/RR'),TO_DATE('07/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','6','235495',TO_DATE('15/01/20','DD/MM/RR'),TO_DATE('25/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','4','825465',TO_DATE('17/01/20','DD/MM/RR'),TO_DATE('12/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','6','405125',TO_DATE('19/01/20','DD/MM/RR'),TO_DATE('28/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','10','489288',TO_DATE('23/12/19','DD/MM/RR'),TO_DATE('09/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','6','885516',TO_DATE('22/12/19','DD/MM/RR'),TO_DATE('15/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','2','861706',TO_DATE('05/01/20','DD/MM/RR'),TO_DATE('19/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','4','642594',TO_DATE('09/01/20','DD/MM/RR'),TO_DATE('01/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','3','124229',TO_DATE('14/10/21','DD/MM/RR'),TO_DATE('13/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','3','547270',TO_DATE('22/09/21','DD/MM/RR'),TO_DATE('08/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','9','751525',TO_DATE('07/10/21','DD/MM/RR'),TO_DATE('28/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','5','720550',TO_DATE('07/10/21','DD/MM/RR'),TO_DATE('02/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','1','579040',TO_DATE('12/10/21','DD/MM/RR'),TO_DATE('03/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','7','345134',TO_DATE('11/10/21','DD/MM/RR'),TO_DATE('15/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','4','614746',TO_DATE('09/10/21','DD/MM/RR'),TO_DATE('09/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','9','722901',TO_DATE('10/10/21','DD/MM/RR'),TO_DATE('09/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','10','725170',TO_DATE('22/10/21','DD/MM/RR'),TO_DATE('02/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','437529',TO_DATE('13/10/21','DD/MM/RR'),TO_DATE('28/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','1','197966',TO_DATE('19/10/21','DD/MM/RR'),TO_DATE('23/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','6','635180',TO_DATE('06/10/21','DD/MM/RR'),TO_DATE('24/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','10','276011',TO_DATE('25/10/21','DD/MM/RR'),TO_DATE('13/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','4','236090',TO_DATE('15/10/21','DD/MM/RR'),TO_DATE('03/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','10','407399',TO_DATE('19/10/21','DD/MM/RR'),TO_DATE('07/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','9','583475',TO_DATE('04/10/21','DD/MM/RR'),TO_DATE('16/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','6','128434',TO_DATE('01/10/21','DD/MM/RR'),TO_DATE('19/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','9','803917',TO_DATE('20/10/21','DD/MM/RR'),TO_DATE('18/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','2','259921',TO_DATE('21/10/21','DD/MM/RR'),TO_DATE('27/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','9','167257',TO_DATE('26/10/21','DD/MM/RR'),TO_DATE('07/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','4','236899',TO_DATE('01/11/21','DD/MM/RR'),TO_DATE('07/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','2','822028',TO_DATE('17/10/21','DD/MM/RR'),TO_DATE('10/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','4','224574',TO_DATE('28/10/21','DD/MM/RR'),TO_DATE('20/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','4','720225',TO_DATE('12/10/21','DD/MM/RR'),TO_DATE('11/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','6','399081',TO_DATE('29/10/21','DD/MM/RR'),TO_DATE('18/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','2','665856',TO_DATE('18/10/21','DD/MM/RR'),TO_DATE('02/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','5','520236',TO_DATE('16/10/21','DD/MM/RR'),TO_DATE('19/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','2','841966',TO_DATE('20/10/21','DD/MM/RR'),TO_DATE('11/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','6','417240',TO_DATE('13/10/21','DD/MM/RR'),TO_DATE('12/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','9','670413',TO_DATE('30/10/21','DD/MM/RR'),TO_DATE('03/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','7','307798',TO_DATE('14/10/21','DD/MM/RR'),TO_DATE('15/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','9','364880',TO_DATE('15/10/21','DD/MM/RR'),TO_DATE('12/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','7','532865',TO_DATE('02/11/21','DD/MM/RR'),TO_DATE('25/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','1','600952',TO_DATE('04/11/21','DD/MM/RR'),TO_DATE('25/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','5','550553',TO_DATE('23/10/21','DD/MM/RR'),TO_DATE('24/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','8','356445',TO_DATE('01/11/21','DD/MM/RR'),TO_DATE('05/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','10','394610',TO_DATE('16/10/21','DD/MM/RR'),TO_DATE('05/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','10','676992',TO_DATE('28/10/21','DD/MM/RR'),TO_DATE('01/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','2','518265',TO_DATE('17/10/21','DD/MM/RR'),TO_DATE('20/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','7','399849',TO_DATE('21/10/21','DD/MM/RR'),TO_DATE('19/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','3','246878',TO_DATE('02/11/21','DD/MM/RR'),TO_DATE('20/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','5','102925',TO_DATE('11/11/21','DD/MM/RR'),TO_DATE('27/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','3','635959',TO_DATE('30/10/21','DD/MM/RR'),TO_DATE('01/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','8','798458',TO_DATE('03/11/21','DD/MM/RR'),TO_DATE('02/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','3','337932',TO_DATE('11/11/21','DD/MM/RR'),TO_DATE('30/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','6','610225',TO_DATE('31/10/21','DD/MM/RR'),TO_DATE('09/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','5','369731',TO_DATE('22/10/21','DD/MM/RR'),TO_DATE('27/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','5','509296',TO_DATE('23/10/21','DD/MM/RR'),TO_DATE('28/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','5','813008',TO_DATE('10/11/21','DD/MM/RR'),TO_DATE('23/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','6','573091',TO_DATE('24/10/21','DD/MM/RR'),TO_DATE('10/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','2','682752',TO_DATE('06/11/21','DD/MM/RR'),TO_DATE('01/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','1','202081',TO_DATE('16/11/21','DD/MM/RR'),TO_DATE('22/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','7','430093',TO_DATE('05/11/21','DD/MM/RR'),TO_DATE('19/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','8','707125',TO_DATE('27/10/21','DD/MM/RR'),TO_DATE('30/11/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','9','305223',TO_DATE('12/11/21','DD/MM/RR'),TO_DATE('03/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','5','269506',TO_DATE('06/11/21','DD/MM/RR'),TO_DATE('10/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','3','768493',TO_DATE('07/11/21','DD/MM/RR'),TO_DATE('03/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','4','826563',TO_DATE('04/11/21','DD/MM/RR'),TO_DATE('10/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','4','163623',TO_DATE('07/11/21','DD/MM/RR'),TO_DATE('31/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','7','318437',TO_DATE('03/11/21','DD/MM/RR'),TO_DATE('21/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','3','833890',TO_DATE('24/10/21','DD/MM/RR'),TO_DATE('02/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','7','591927',TO_DATE('17/11/21','DD/MM/RR'),TO_DATE('27/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','5','892923',TO_DATE('17/11/21','DD/MM/RR'),TO_DATE('20/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','7','723077',TO_DATE('16/11/21','DD/MM/RR'),TO_DATE('13/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','8','790515',TO_DATE('25/10/21','DD/MM/RR'),TO_DATE('10/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','5','807840',TO_DATE('26/10/21','DD/MM/RR'),TO_DATE('23/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','4','632835',TO_DATE('27/10/21','DD/MM/RR'),TO_DATE('18/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','1','610178',TO_DATE('10/11/21','DD/MM/RR'),TO_DATE('12/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','3','723779',TO_DATE('15/11/21','DD/MM/RR'),TO_DATE('08/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','6','456164',TO_DATE('19/11/21','DD/MM/RR'),TO_DATE('08/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','9','334334',TO_DATE('31/10/21','DD/MM/RR'),TO_DATE('26/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','4','706794',TO_DATE('20/11/21','DD/MM/RR'),TO_DATE('15/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','1','694754',TO_DATE('14/11/21','DD/MM/RR'),TO_DATE('07/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','9','374988',TO_DATE('26/11/21','DD/MM/RR'),TO_DATE('09/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','6','550690',TO_DATE('29/10/21','DD/MM/RR'),TO_DATE('12/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','7','272672',TO_DATE('20/11/21','DD/MM/RR'),TO_DATE('31/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','9','636658',TO_DATE('15/11/21','DD/MM/RR'),TO_DATE('03/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','1','101064',TO_DATE('19/11/21','DD/MM/RR'),TO_DATE('19/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','3','591577',TO_DATE('25/11/21','DD/MM/RR'),TO_DATE('08/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','6','152947',TO_DATE('18/11/21','DD/MM/RR'),TO_DATE('18/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','2','136543',TO_DATE('05/11/21','DD/MM/RR'),TO_DATE('04/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','3','839273',TO_DATE('21/11/21','DD/MM/RR'),TO_DATE('05/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','9','475901',TO_DATE('27/11/21','DD/MM/RR'),TO_DATE('19/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','2','595476',TO_DATE('13/11/21','DD/MM/RR'),TO_DATE('26/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','3','374859',TO_DATE('22/11/21','DD/MM/RR'),TO_DATE('28/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','4','850291',TO_DATE('08/11/21','DD/MM/RR'),TO_DATE('12/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','10','332198',TO_DATE('12/11/21','DD/MM/RR'),TO_DATE('23/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','2','153052',TO_DATE('21/11/21','DD/MM/RR'),TO_DATE('25/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','4','720049',TO_DATE('09/11/21','DD/MM/RR'),TO_DATE('30/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','4','747461',TO_DATE('09/11/21','DD/MM/RR'),TO_DATE('30/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','1','308881',TO_DATE('28/11/21','DD/MM/RR'),TO_DATE('31/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','7','486988',TO_DATE('03/12/21','DD/MM/RR'),TO_DATE('26/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','7','586575',TO_DATE('04/12/21','DD/MM/RR'),TO_DATE('19/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','9','342602',TO_DATE('30/11/21','DD/MM/RR'),TO_DATE('14/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','9','315483',TO_DATE('25/11/21','DD/MM/RR'),TO_DATE('19/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','10','313399',TO_DATE('01/12/21','DD/MM/RR'),TO_DATE('19/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','4','727183',TO_DATE('08/11/21','DD/MM/RR'),TO_DATE('19/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','5','118532',TO_DATE('07/12/21','DD/MM/RR'),TO_DATE('13/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','9','416150',TO_DATE('14/11/21','DD/MM/RR'),TO_DATE('28/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','10','855167',TO_DATE('30/11/21','DD/MM/RR'),TO_DATE('13/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','3','243608',TO_DATE('23/11/21','DD/MM/RR'),TO_DATE('11/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','3','787834',TO_DATE('07/12/21','DD/MM/RR'),TO_DATE('07/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','2','794518',TO_DATE('13/11/21','DD/MM/RR'),TO_DATE('26/12/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','6','685067',TO_DATE('08/12/21','DD/MM/RR'),TO_DATE('27/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','7','826896',TO_DATE('06/12/21','DD/MM/RR'),TO_DATE('07/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','5','750988',TO_DATE('11/12/21','DD/MM/RR'),TO_DATE('14/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','1','517439',TO_DATE('13/12/21','DD/MM/RR'),TO_DATE('31/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','728883',TO_DATE('03/12/21','DD/MM/RR'),TO_DATE('23/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','7','242906',TO_DATE('05/12/21','DD/MM/RR'),TO_DATE('12/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','4','309444',TO_DATE('01/12/21','DD/MM/RR'),TO_DATE('28/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','3','148858',TO_DATE('06/12/21','DD/MM/RR'),TO_DATE('26/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','7','560436',TO_DATE('20/12/21','DD/MM/RR'),TO_DATE('03/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','8','811677',TO_DATE('24/11/21','DD/MM/RR'),TO_DATE('10/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','5','153403',TO_DATE('02/12/21','DD/MM/RR'),TO_DATE('14/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','2','115246',TO_DATE('24/11/21','DD/MM/RR'),TO_DATE('06/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','7','847317',TO_DATE('19/12/21','DD/MM/RR'),TO_DATE('10/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','8','387378',TO_DATE('28/11/21','DD/MM/RR'),TO_DATE('12/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','10','251505',TO_DATE('04/12/21','DD/MM/RR'),TO_DATE('06/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','10','528445',TO_DATE('29/11/21','DD/MM/RR'),TO_DATE('23/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','8','854400',TO_DATE('05/12/21','DD/MM/RR'),TO_DATE('30/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','9','398562',TO_DATE('29/11/21','DD/MM/RR'),TO_DATE('04/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','8','840866',TO_DATE('09/12/21','DD/MM/RR'),TO_DATE('02/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','4','682762',TO_DATE('26/11/21','DD/MM/RR'),TO_DATE('11/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','10','627033',TO_DATE('08/12/21','DD/MM/RR'),TO_DATE('19/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','10','195404',TO_DATE('19/12/21','DD/MM/RR'),TO_DATE('08/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','10','184546',TO_DATE('02/12/21','DD/MM/RR'),TO_DATE('16/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','4','679189',TO_DATE('28/12/21','DD/MM/RR'),TO_DATE('07/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','5','882063',TO_DATE('12/12/21','DD/MM/RR'),TO_DATE('11/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','4','358314',TO_DATE('14/12/21','DD/MM/RR'),TO_DATE('31/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','5','344996',TO_DATE('17/12/21','DD/MM/RR'),TO_DATE('25/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','10','297059',TO_DATE('18/12/21','DD/MM/RR'),TO_DATE('14/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','2','620624',TO_DATE('20/12/21','DD/MM/RR'),TO_DATE('26/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','204949',TO_DATE('21/12/21','DD/MM/RR'),TO_DATE('16/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','2','758093',TO_DATE('26/12/21','DD/MM/RR'),TO_DATE('31/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','8','336541',TO_DATE('23/12/21','DD/MM/RR'),TO_DATE('20/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','10','580135',TO_DATE('15/12/21','DD/MM/RR'),TO_DATE('19/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','8','628346',TO_DATE('10/12/21','DD/MM/RR'),TO_DATE('07/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','6','880729',TO_DATE('16/12/21','DD/MM/RR'),TO_DATE('20/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','3','895835',TO_DATE('29/12/21','DD/MM/RR'),TO_DATE('04/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','2','341133',TO_DATE('21/12/21','DD/MM/RR'),TO_DATE('07/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','3','777169',TO_DATE('12/12/21','DD/MM/RR'),TO_DATE('30/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','1','725588',TO_DATE('10/12/21','DD/MM/RR'),TO_DATE('22/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','549773',TO_DATE('13/12/21','DD/MM/RR'),TO_DATE('16/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','9','611766',TO_DATE('16/12/21','DD/MM/RR'),TO_DATE('13/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','2','460783',TO_DATE('24/12/21','DD/MM/RR'),TO_DATE('25/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','6','415607',TO_DATE('15/12/21','DD/MM/RR'),TO_DATE('26/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','3','365285',TO_DATE('23/12/21','DD/MM/RR'),TO_DATE('02/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','10','565417',TO_DATE('11/12/21','DD/MM/RR'),TO_DATE('13/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','3','261116',TO_DATE('24/12/21','DD/MM/RR'),TO_DATE('05/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','7','600815',TO_DATE('22/12/21','DD/MM/RR'),TO_DATE('20/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','6','113842',TO_DATE('17/12/21','DD/MM/RR'),TO_DATE('25/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','10','574919',TO_DATE('14/12/21','DD/MM/RR'),TO_DATE('01/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','8','179534',TO_DATE('30/12/21','DD/MM/RR'),TO_DATE('24/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','7','465701',TO_DATE('31/12/21','DD/MM/RR'),TO_DATE('21/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','10','352036',TO_DATE('22/12/21','DD/MM/RR'),TO_DATE('21/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','7','399835',TO_DATE('18/12/21','DD/MM/RR'),TO_DATE('08/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','10','241079',TO_DATE('25/12/21','DD/MM/RR'),TO_DATE('05/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','5','426621',TO_DATE('26/12/21','DD/MM/RR'),TO_DATE('13/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','7','797682',TO_DATE('28/12/21','DD/MM/RR'),TO_DATE('12/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','9','104634',TO_DATE('27/12/21','DD/MM/RR'),TO_DATE('04/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','1','243244',TO_DATE('25/12/21','DD/MM/RR'),TO_DATE('17/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','6','848417',TO_DATE('30/12/21','DD/MM/RR'),TO_DATE('24/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','9','276391',TO_DATE('29/12/21','DD/MM/RR'),TO_DATE('25/02/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','6','591809',TO_DATE('27/12/21','DD/MM/RR'),TO_DATE('26/01/22','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','8','524926',TO_DATE('25/05/21','DD/MM/RR'),TO_DATE('20/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','4','794790',TO_DATE('12/06/21','DD/MM/RR'),TO_DATE('28/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','3','581635',TO_DATE('14/06/21','DD/MM/RR'),TO_DATE('21/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','2','206310',TO_DATE('26/05/21','DD/MM/RR'),TO_DATE('23/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','5','813008',TO_DATE('19/05/21','DD/MM/RR'),TO_DATE('18/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','10','246231',TO_DATE('13/06/21','DD/MM/RR'),TO_DATE('08/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','9','162612',TO_DATE('11/06/21','DD/MM/RR'),TO_DATE('14/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','8','757433',TO_DATE('20/05/21','DD/MM/RR'),TO_DATE('27/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','7','881210',TO_DATE('02/06/21','DD/MM/RR'),TO_DATE('31/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','7','544028',TO_DATE('04/06/21','DD/MM/RR'),TO_DATE('29/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','1','588483',TO_DATE('09/06/21','DD/MM/RR'),TO_DATE('26/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','1','813253',TO_DATE('07/06/21','DD/MM/RR'),TO_DATE('19/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','4','679250',TO_DATE('10/06/21','DD/MM/RR'),TO_DATE('08/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','3','839273',TO_DATE('10/06/21','DD/MM/RR'),TO_DATE('18/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','5','649763',TO_DATE('26/05/21','DD/MM/RR'),TO_DATE('20/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','3','857320',TO_DATE('28/05/21','DD/MM/RR'),TO_DATE('25/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','9','315483',TO_DATE('18/06/21','DD/MM/RR'),TO_DATE('12/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','9','563623',TO_DATE('21/06/21','DD/MM/RR'),TO_DATE('23/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','3','382376',TO_DATE('03/06/21','DD/MM/RR'),TO_DATE('22/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','7','391567',TO_DATE('15/06/21','DD/MM/RR'),TO_DATE('02/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','1','157139',TO_DATE('22/06/21','DD/MM/RR'),TO_DATE('16/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','5','131357',TO_DATE('12/06/21','DD/MM/RR'),TO_DATE('14/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','5','101108',TO_DATE('19/06/21','DD/MM/RR'),TO_DATE('05/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','2','509925',TO_DATE('03/06/21','DD/MM/RR'),TO_DATE('17/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','9','719915',TO_DATE('19/06/21','DD/MM/RR'),TO_DATE('30/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','1','378580',TO_DATE('05/06/21','DD/MM/RR'),TO_DATE('11/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','4','706794',TO_DATE('08/06/21','DD/MM/RR'),TO_DATE('22/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','4','309444',TO_DATE('30/06/21','DD/MM/RR'),TO_DATE('21/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','7','772056',TO_DATE('01/06/21','DD/MM/RR'),TO_DATE('15/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','4','252010',TO_DATE('29/06/21','DD/MM/RR'),TO_DATE('28/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','6','536281',TO_DATE('06/06/21','DD/MM/RR'),TO_DATE('04/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','6','334259',TO_DATE('13/06/21','DD/MM/RR'),TO_DATE('28/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','10','490381',TO_DATE('27/06/21','DD/MM/RR'),TO_DATE('30/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','1','469045',TO_DATE('23/06/21','DD/MM/RR'),TO_DATE('08/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','1','308881',TO_DATE('24/06/21','DD/MM/RR'),TO_DATE('19/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','7','342306',TO_DATE('27/06/21','DD/MM/RR'),TO_DATE('11/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','7','527004',TO_DATE('16/06/21','DD/MM/RR'),TO_DATE('10/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','4','445222',TO_DATE('23/06/21','DD/MM/RR'),TO_DATE('18/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','9','460439',TO_DATE('15/06/21','DD/MM/RR'),TO_DATE('26/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','2','165671',TO_DATE('14/06/21','DD/MM/RR'),TO_DATE('12/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','352629',TO_DATE('24/06/21','DD/MM/RR'),TO_DATE('27/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','6','100247',TO_DATE('25/06/21','DD/MM/RR'),TO_DATE('22/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','10','444969',TO_DATE('05/07/21','DD/MM/RR'),TO_DATE('03/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','3','890710',TO_DATE('06/07/21','DD/MM/RR'),TO_DATE('03/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','4','259927',TO_DATE('28/06/21','DD/MM/RR'),TO_DATE('11/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','7','242906',TO_DATE('08/07/21','DD/MM/RR'),TO_DATE('24/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','10','651741',TO_DATE('25/06/21','DD/MM/RR'),TO_DATE('19/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','5','481478',TO_DATE('29/06/21','DD/MM/RR'),TO_DATE('28/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','4','124437',TO_DATE('08/07/21','DD/MM/RR'),TO_DATE('25/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','8','811677',TO_DATE('16/06/21','DD/MM/RR'),TO_DATE('30/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','9','794347',TO_DATE('17/06/21','DD/MM/RR'),TO_DATE('02/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','3','655349',TO_DATE('17/06/21','DD/MM/RR'),TO_DATE('01/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','8','163378',TO_DATE('05/07/21','DD/MM/RR'),TO_DATE('13/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','9','619219',TO_DATE('09/07/21','DD/MM/RR'),TO_DATE('19/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','1','337320',TO_DATE('26/06/21','DD/MM/RR'),TO_DATE('15/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','9','475901',TO_DATE('22/06/21','DD/MM/RR'),TO_DATE('30/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','6','282337',TO_DATE('01/07/21','DD/MM/RR'),TO_DATE('28/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','7','582159',TO_DATE('21/06/21','DD/MM/RR'),TO_DATE('21/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','2','177083',TO_DATE('11/07/21','DD/MM/RR'),TO_DATE('15/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','6','566899',TO_DATE('04/07/21','DD/MM/RR'),TO_DATE('18/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','10','525265',TO_DATE('11/07/21','DD/MM/RR'),TO_DATE('03/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','7','657137',TO_DATE('09/07/21','DD/MM/RR'),TO_DATE('31/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','9','374988',TO_DATE('20/06/21','DD/MM/RR'),TO_DATE('22/07/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','8','450737',TO_DATE('18/06/21','DD/MM/RR'),TO_DATE('02/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','10','513491',TO_DATE('16/07/21','DD/MM/RR'),TO_DATE('02/09/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','7','163624',TO_DATE('20/06/21','DD/MM/RR'),TO_DATE('14/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','1','211018',TO_DATE('01/07/21','DD/MM/RR'),TO_DATE('23/08/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','6','762144',TO_DATE('18/01/21','DD/MM/RR'),TO_DATE('18/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','8','357081',TO_DATE('13/01/21','DD/MM/RR'),TO_DATE('07/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','5','541412',TO_DATE('15/01/21','DD/MM/RR'),TO_DATE('21/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','4','753757',TO_DATE('25/01/21','DD/MM/RR'),TO_DATE('05/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','7','854734',TO_DATE('10/01/21','DD/MM/RR'),TO_DATE('03/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','2','373655',TO_DATE('06/01/21','DD/MM/RR'),TO_DATE('01/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','9','842254',TO_DATE('23/01/21','DD/MM/RR'),TO_DATE('14/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','10','553521',TO_DATE('07/01/21','DD/MM/RR'),TO_DATE('02/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','10','596888',TO_DATE('24/01/21','DD/MM/RR'),TO_DATE('03/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','1','804165',TO_DATE('03/01/21','DD/MM/RR'),TO_DATE('01/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','9','259663',TO_DATE('08/01/21','DD/MM/RR'),TO_DATE('09/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','4','241926',TO_DATE('25/01/21','DD/MM/RR'),TO_DATE('22/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','6','614724',TO_DATE('05/01/21','DD/MM/RR'),TO_DATE('12/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','10','204095',TO_DATE('23/01/21','DD/MM/RR'),TO_DATE('02/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','3','127845',TO_DATE('04/01/21','DD/MM/RR'),TO_DATE('08/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','9','676347',TO_DATE('28/01/21','DD/MM/RR'),TO_DATE('10/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','9','719801',TO_DATE('01/02/21','DD/MM/RR'),TO_DATE('28/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','6','834580',TO_DATE('05/01/21','DD/MM/RR'),TO_DATE('26/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','5','151445',TO_DATE('01/02/21','DD/MM/RR'),TO_DATE('20/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','9','100244',TO_DATE('24/01/21','DD/MM/RR'),TO_DATE('18/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','2','837695',TO_DATE('14/01/21','DD/MM/RR'),TO_DATE('20/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','4','560242',TO_DATE('04/02/21','DD/MM/RR'),TO_DATE('27/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','4','424580',TO_DATE('08/01/21','DD/MM/RR'),TO_DATE('09/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','9','238337',TO_DATE('22/01/21','DD/MM/RR'),TO_DATE('05/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','8','269376',TO_DATE('02/02/21','DD/MM/RR'),TO_DATE('23/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','3','751505',TO_DATE('18/01/21','DD/MM/RR'),TO_DATE('18/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','3','474488',TO_DATE('16/01/21','DD/MM/RR'),TO_DATE('07/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','3','819817',TO_DATE('26/01/21','DD/MM/RR'),TO_DATE('28/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','10','473839',TO_DATE('12/01/21','DD/MM/RR'),TO_DATE('01/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','2','669056',TO_DATE('21/01/21','DD/MM/RR'),TO_DATE('01/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','3','490602',TO_DATE('27/01/21','DD/MM/RR'),TO_DATE('16/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','9','587268',TO_DATE('28/01/21','DD/MM/RR'),TO_DATE('26/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','7','577275',TO_DATE('08/02/21','DD/MM/RR'),TO_DATE('18/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','9','418129',TO_DATE('20/01/21','DD/MM/RR'),TO_DATE('19/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','6','212292',TO_DATE('05/02/21','DD/MM/RR'),TO_DATE('06/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','1','532065',TO_DATE('10/02/21','DD/MM/RR'),TO_DATE('28/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','10','878506',TO_DATE('30/01/21','DD/MM/RR'),TO_DATE('04/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','8','612144',TO_DATE('30/01/21','DD/MM/RR'),TO_DATE('14/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','2','754594',TO_DATE('08/02/21','DD/MM/RR'),TO_DATE('01/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','9','432595',TO_DATE('27/01/21','DD/MM/RR'),TO_DATE('27/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','5','214643',TO_DATE('09/02/21','DD/MM/RR'),TO_DATE('26/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','8','872666',TO_DATE('17/01/21','DD/MM/RR'),TO_DATE('21/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','6','522973',TO_DATE('20/01/21','DD/MM/RR'),TO_DATE('01/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','2','743522',TO_DATE('06/02/21','DD/MM/RR'),TO_DATE('22/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','4','358892',TO_DATE('31/01/21','DD/MM/RR'),TO_DATE('02/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','9','101589',TO_DATE('12/02/21','DD/MM/RR'),TO_DATE('30/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','2','240825',TO_DATE('13/02/21','DD/MM/RR'),TO_DATE('01/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','4','109912',TO_DATE('05/02/21','DD/MM/RR'),TO_DATE('28/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','1','379984',TO_DATE('11/02/21','DD/MM/RR'),TO_DATE('23/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','6','841072',TO_DATE('22/01/21','DD/MM/RR'),TO_DATE('24/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','10','839112',TO_DATE('02/02/21','DD/MM/RR'),TO_DATE('13/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','1','154628',TO_DATE('19/02/21','DD/MM/RR'),TO_DATE('28/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','10','352026',TO_DATE('23/02/21','DD/MM/RR'),TO_DATE('23/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','1','188570',TO_DATE('12/02/21','DD/MM/RR'),TO_DATE('15/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','604222',TO_DATE('10/02/21','DD/MM/RR'),TO_DATE('11/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','7','602983',TO_DATE('26/01/21','DD/MM/RR'),TO_DATE('22/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','6','220118',TO_DATE('31/01/21','DD/MM/RR'),TO_DATE('03/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','1','575736',TO_DATE('15/02/21','DD/MM/RR'),TO_DATE('14/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','10','357670',TO_DATE('29/01/21','DD/MM/RR'),TO_DATE('18/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','7','314359',TO_DATE('06/02/21','DD/MM/RR'),TO_DATE('02/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','2','232982',TO_DATE('15/02/21','DD/MM/RR'),TO_DATE('09/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','8','349088',TO_DATE('29/01/21','DD/MM/RR'),TO_DATE('22/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','4','675222',TO_DATE('07/02/21','DD/MM/RR'),TO_DATE('27/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','5','569015',TO_DATE('21/02/21','DD/MM/RR'),TO_DATE('02/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','6','386909',TO_DATE('07/02/21','DD/MM/RR'),TO_DATE('22/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','2','811376',TO_DATE('20/02/21','DD/MM/RR'),TO_DATE('24/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','10','605823',TO_DATE('22/02/21','DD/MM/RR'),TO_DATE('13/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','2','574687',TO_DATE('01/03/21','DD/MM/RR'),TO_DATE('19/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','4','519477',TO_DATE('04/02/21','DD/MM/RR'),TO_DATE('26/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','4','748130',TO_DATE('01/03/21','DD/MM/RR'),TO_DATE('08/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','10','735648',TO_DATE('03/02/21','DD/MM/RR'),TO_DATE('10/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','10','108125',TO_DATE('16/02/21','DD/MM/RR'),TO_DATE('03/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','2','214841',TO_DATE('20/02/21','DD/MM/RR'),TO_DATE('21/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','5','842476',TO_DATE('13/02/21','DD/MM/RR'),TO_DATE('01/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','7','347765',TO_DATE('11/02/21','DD/MM/RR'),TO_DATE('12/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','6','213097',TO_DATE('03/02/21','DD/MM/RR'),TO_DATE('26/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','6','128434',TO_DATE('28/02/21','DD/MM/RR'),TO_DATE('03/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','8','569238',TO_DATE('25/02/21','DD/MM/RR'),TO_DATE('12/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','6','593197',TO_DATE('17/02/21','DD/MM/RR'),TO_DATE('15/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','4','163488',TO_DATE('14/02/21','DD/MM/RR'),TO_DATE('20/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','2','426970',TO_DATE('05/03/21','DD/MM/RR'),TO_DATE('19/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','6','308650',TO_DATE('09/02/21','DD/MM/RR'),TO_DATE('29/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','5','302171',TO_DATE('24/02/21','DD/MM/RR'),TO_DATE('17/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','5','546783',TO_DATE('18/02/21','DD/MM/RR'),TO_DATE('31/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','3','321738',TO_DATE('06/03/21','DD/MM/RR'),TO_DATE('05/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','10','191736',TO_DATE('23/02/21','DD/MM/RR'),TO_DATE('12/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','2','597761',TO_DATE('27/02/21','DD/MM/RR'),TO_DATE('26/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','2','861706',TO_DATE('05/03/21','DD/MM/RR'),TO_DATE('16/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','5','270968',TO_DATE('03/03/21','DD/MM/RR'),TO_DATE('21/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','3','804914',TO_DATE('11/03/21','DD/MM/RR'),TO_DATE('14/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','6','235495',TO_DATE('10/03/21','DD/MM/RR'),TO_DATE('16/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','5','224512',TO_DATE('14/02/21','DD/MM/RR'),TO_DATE('23/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','3','304586',TO_DATE('21/02/21','DD/MM/RR'),TO_DATE('06/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','5','559822',TO_DATE('27/02/21','DD/MM/RR'),TO_DATE('20/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','7','750250',TO_DATE('07/03/21','DD/MM/RR'),TO_DATE('28/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','5','567659',TO_DATE('16/02/21','DD/MM/RR'),TO_DATE('19/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','4','614746',TO_DATE('16/03/21','DD/MM/RR'),TO_DATE('06/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','9','228588',TO_DATE('26/02/21','DD/MM/RR'),TO_DATE('01/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','1','653032',TO_DATE('16/03/21','DD/MM/RR'),TO_DATE('12/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','5','396442',TO_DATE('18/03/21','DD/MM/RR'),TO_DATE('25/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','1','701925',TO_DATE('17/02/21','DD/MM/RR'),TO_DATE('20/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','5','704759',TO_DATE('19/02/21','DD/MM/RR'),TO_DATE('31/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','5','124218',TO_DATE('02/03/21','DD/MM/RR'),TO_DATE('19/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','4','112325',TO_DATE('18/02/21','DD/MM/RR'),TO_DATE('11/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','4','538747',TO_DATE('22/02/21','DD/MM/RR'),TO_DATE('26/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','2','712560',TO_DATE('14/03/21','DD/MM/RR'),TO_DATE('03/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','2','849318',TO_DATE('20/03/21','DD/MM/RR'),TO_DATE('29/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','6','785394',TO_DATE('13/03/21','DD/MM/RR'),TO_DATE('05/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','3','127144',TO_DATE('19/03/21','DD/MM/RR'),TO_DATE('18/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','6','635180',TO_DATE('10/03/21','DD/MM/RR'),TO_DATE('11/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','4','713705',TO_DATE('04/03/21','DD/MM/RR'),TO_DATE('28/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','8','729764',TO_DATE('22/03/21','DD/MM/RR'),TO_DATE('01/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','10','598845',TO_DATE('24/02/21','DD/MM/RR'),TO_DATE('20/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','5','720550',TO_DATE('12/03/21','DD/MM/RR'),TO_DATE('23/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','5','699913',TO_DATE('03/03/21','DD/MM/RR'),TO_DATE('14/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','4','642594',TO_DATE('07/03/21','DD/MM/RR'),TO_DATE('06/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','7','179702',TO_DATE('14/03/21','DD/MM/RR'),TO_DATE('12/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','6','417240',TO_DATE('24/03/21','DD/MM/RR'),TO_DATE('04/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','8','847420',TO_DATE('26/02/21','DD/MM/RR'),TO_DATE('17/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','3','759216',TO_DATE('02/03/21','DD/MM/RR'),TO_DATE('26/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','9','391200',TO_DATE('20/03/21','DD/MM/RR'),TO_DATE('04/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','6','560953',TO_DATE('25/02/21','DD/MM/RR'),TO_DATE('05/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','4','825465',TO_DATE('11/03/21','DD/MM/RR'),TO_DATE('01/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','2','769625',TO_DATE('25/03/21','DD/MM/RR'),TO_DATE('02/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','8','737744',TO_DATE('21/03/21','DD/MM/RR'),TO_DATE('04/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','6','405125',TO_DATE('12/03/21','DD/MM/RR'),TO_DATE('21/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','10','217709',TO_DATE('27/03/21','DD/MM/RR'),TO_DATE('29/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','1','162303',TO_DATE('29/03/21','DD/MM/RR'),TO_DATE('29/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','140776',TO_DATE('28/02/21','DD/MM/RR'),TO_DATE('18/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','2','145248',TO_DATE('04/03/21','DD/MM/RR'),TO_DATE('01/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','10','290565',TO_DATE('02/04/21','DD/MM/RR'),TO_DATE('17/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','6','812269',TO_DATE('17/03/21','DD/MM/RR'),TO_DATE('24/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','7','889380',TO_DATE('06/03/21','DD/MM/RR'),TO_DATE('16/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','10','355940',TO_DATE('08/03/21','DD/MM/RR'),TO_DATE('26/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','3','104237',TO_DATE('15/03/21','DD/MM/RR'),TO_DATE('25/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','7','337917',TO_DATE('31/03/21','DD/MM/RR'),TO_DATE('28/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','5','378636',TO_DATE('03/04/21','DD/MM/RR'),TO_DATE('02/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','4','655853',TO_DATE('18/03/21','DD/MM/RR'),TO_DATE('21/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','5','513237',TO_DATE('05/04/21','DD/MM/RR'),TO_DATE('07/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','1','285863',TO_DATE('09/03/21','DD/MM/RR'),TO_DATE('08/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','4','878717',TO_DATE('19/03/21','DD/MM/RR'),TO_DATE('03/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','3','310979',TO_DATE('08/03/21','DD/MM/RR'),TO_DATE('26/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','9','436865',TO_DATE('09/03/21','DD/MM/RR'),TO_DATE('16/04/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','6','437353',TO_DATE('13/03/21','DD/MM/RR'),TO_DATE('10/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','1','897488',TO_DATE('04/04/21','DD/MM/RR'),TO_DATE('07/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','1','658822',TO_DATE('06/04/21','DD/MM/RR'),TO_DATE('19/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','1','697968',TO_DATE('31/03/21','DD/MM/RR'),TO_DATE('14/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','2','822028',TO_DATE('01/04/21','DD/MM/RR'),TO_DATE('22/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','9','803917',TO_DATE('07/04/21','DD/MM/RR'),TO_DATE('01/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','10','547600',TO_DATE('08/04/21','DD/MM/RR'),TO_DATE('21/05/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','10','186652',TO_DATE('10/04/21','DD/MM/RR'),TO_DATE('09/06/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','1','378580',TO_DATE('07/07/20','DD/MM/RR'),TO_DATE('29/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','5','131357',TO_DATE('21/07/20','DD/MM/RR'),TO_DATE('24/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','3','655349',TO_DATE('31/07/20','DD/MM/RR'),TO_DATE('22/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','9','436173',TO_DATE('20/07/20','DD/MM/RR'),TO_DATE('10/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','2','241544',TO_DATE('10/07/20','DD/MM/RR'),TO_DATE('24/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','2','165671',TO_DATE('25/07/20','DD/MM/RR'),TO_DATE('15/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','6','435874',TO_DATE('01/08/20','DD/MM/RR'),TO_DATE('23/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','9','872977',TO_DATE('30/07/20','DD/MM/RR'),TO_DATE('28/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','4','679250',TO_DATE('17/07/20','DD/MM/RR'),TO_DATE('13/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','7','245030',TO_DATE('18/07/20','DD/MM/RR'),TO_DATE('24/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','9','689359',TO_DATE('26/07/20','DD/MM/RR'),TO_DATE('30/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','2','696580',TO_DATE('28/07/20','DD/MM/RR'),TO_DATE('02/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','8','666193',TO_DATE('11/08/20','DD/MM/RR'),TO_DATE('24/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','6','184475',TO_DATE('19/07/20','DD/MM/RR'),TO_DATE('12/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','4','445222',TO_DATE('12/08/20','DD/MM/RR'),TO_DATE('13/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','6','100247',TO_DATE('16/08/20','DD/MM/RR'),TO_DATE('13/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','6','334259',TO_DATE('23/07/20','DD/MM/RR'),TO_DATE('31/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','8','450737',TO_DATE('02/08/20','DD/MM/RR'),TO_DATE('05/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','3','488689',TO_DATE('03/08/20','DD/MM/RR'),TO_DATE('20/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','2','554616',TO_DATE('07/08/20','DD/MM/RR'),TO_DATE('14/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','7','391567',TO_DATE('27/07/20','DD/MM/RR'),TO_DATE('22/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','10','600789',TO_DATE('19/08/20','DD/MM/RR'),TO_DATE('02/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','8','264616',TO_DATE('21/08/20','DD/MM/RR'),TO_DATE('10/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','1','491435',TO_DATE('05/08/20','DD/MM/RR'),TO_DATE('04/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','10','539354',TO_DATE('17/08/20','DD/MM/RR'),TO_DATE('10/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','1','211018',TO_DATE('28/08/20','DD/MM/RR'),TO_DATE('22/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','3','389188',TO_DATE('09/08/20','DD/MM/RR'),TO_DATE('08/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','7','288615',TO_DATE('25/08/20','DD/MM/RR'),TO_DATE('03/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','1','157139',TO_DATE('10/08/20','DD/MM/RR'),TO_DATE('01/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','5','481478',TO_DATE('24/08/20','DD/MM/RR'),TO_DATE('18/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','9','719915',TO_DATE('04/08/20','DD/MM/RR'),TO_DATE('22/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','4','259927',TO_DATE('22/08/20','DD/MM/RR'),TO_DATE('06/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','9','617883',TO_DATE('15/08/20','DD/MM/RR'),TO_DATE('27/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','352629',TO_DATE('14/08/20','DD/MM/RR'),TO_DATE('30/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','1','804165',TO_DATE('02/09/20','DD/MM/RR'),TO_DATE('25/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','10','490381',TO_DATE('20/08/20','DD/MM/RR'),TO_DATE('17/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','7','163624',TO_DATE('06/08/20','DD/MM/RR'),TO_DATE('24/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','10','444969',TO_DATE('05/09/20','DD/MM/RR'),TO_DATE('22/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','7','582159',TO_DATE('08/08/20','DD/MM/RR'),TO_DATE('07/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','1','337320',TO_DATE('18/08/20','DD/MM/RR'),TO_DATE('26/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','1','194808',TO_DATE('26/08/20','DD/MM/RR'),TO_DATE('15/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','3','890710',TO_DATE('07/09/20','DD/MM/RR'),TO_DATE('30/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','8','894697',TO_DATE('30/08/20','DD/MM/RR'),TO_DATE('15/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','10','543913',TO_DATE('29/08/20','DD/MM/RR'),TO_DATE('12/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','8','627918',TO_DATE('13/08/20','DD/MM/RR'),TO_DATE('06/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','2','373655',TO_DATE('08/09/20','DD/MM/RR'),TO_DATE('30/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','7','352719',TO_DATE('27/08/20','DD/MM/RR'),TO_DATE('16/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','8','270391',TO_DATE('23/08/20','DD/MM/RR'),TO_DATE('25/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','7','301220',TO_DATE('18/09/20','DD/MM/RR'),TO_DATE('24/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','9','642486',TO_DATE('04/09/20','DD/MM/RR'),TO_DATE('13/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','10','803426',TO_DATE('01/09/20','DD/MM/RR'),TO_DATE('22/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','10','553521',TO_DATE('10/09/20','DD/MM/RR'),TO_DATE('07/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','10','473839',TO_DATE('20/09/20','DD/MM/RR'),TO_DATE('12/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','10','525265',TO_DATE('17/09/20','DD/MM/RR'),TO_DATE('27/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','6','614724',TO_DATE('06/09/20','DD/MM/RR'),TO_DATE('07/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','7','657137',TO_DATE('13/09/20','DD/MM/RR'),TO_DATE('29/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','10','138705',TO_DATE('30/08/20','DD/MM/RR'),TO_DATE('24/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','2','837695',TO_DATE('24/09/20','DD/MM/RR'),TO_DATE('08/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','9','832116',TO_DATE('16/09/20','DD/MM/RR'),TO_DATE('19/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','6','468336',TO_DATE('14/09/20','DD/MM/RR'),TO_DATE('18/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','5','861126',TO_DATE('21/09/20','DD/MM/RR'),TO_DATE('09/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','10','690117',TO_DATE('25/09/20','DD/MM/RR'),TO_DATE('28/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','6','566899',TO_DATE('03/09/20','DD/MM/RR'),TO_DATE('02/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','4','124437',TO_DATE('11/09/20','DD/MM/RR'),TO_DATE('07/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','9','115804',TO_DATE('19/09/20','DD/MM/RR'),TO_DATE('24/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','4','380325',TO_DATE('09/09/20','DD/MM/RR'),TO_DATE('11/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','9','259663',TO_DATE('12/09/20','DD/MM/RR'),TO_DATE('21/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','8','262119',TO_DATE('01/10/20','DD/MM/RR'),TO_DATE('06/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','10','308215',TO_DATE('15/09/20','DD/MM/RR'),TO_DATE('30/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','6','762144',TO_DATE('02/10/20','DD/MM/RR'),TO_DATE('18/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','6','841072',TO_DATE('10/10/20','DD/MM/RR'),TO_DATE('19/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','5','210397',TO_DATE('23/09/20','DD/MM/RR'),TO_DATE('23/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','10','513491',TO_DATE('27/09/20','DD/MM/RR'),TO_DATE('21/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','8','872666',TO_DATE('30/09/20','DD/MM/RR'),TO_DATE('30/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','8','357081',TO_DATE('22/09/20','DD/MM/RR'),TO_DATE('22/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','3','644176',TO_DATE('04/10/20','DD/MM/RR'),TO_DATE('24/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','10','204095',TO_DATE('12/10/20','DD/MM/RR'),TO_DATE('22/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','3','474488',TO_DATE('28/09/20','DD/MM/RR'),TO_DATE('04/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','5','404939',TO_DATE('15/10/20','DD/MM/RR'),TO_DATE('03/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','2','669056',TO_DATE('08/10/20','DD/MM/RR'),TO_DATE('05/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','5','727264',TO_DATE('07/10/20','DD/MM/RR'),TO_DATE('19/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','3','874340',TO_DATE('09/10/20','DD/MM/RR'),TO_DATE('26/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','3','567136',TO_DATE('26/09/20','DD/MM/RR'),TO_DATE('30/10/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','9','587268',TO_DATE('22/10/20','DD/MM/RR'),TO_DATE('15/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','6','471818',TO_DATE('25/10/20','DD/MM/RR'),TO_DATE('23/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','3','293579',TO_DATE('17/10/20','DD/MM/RR'),TO_DATE('29/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','6','604528',TO_DATE('27/10/20','DD/MM/RR'),TO_DATE('30/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','7','132806',TO_DATE('29/09/20','DD/MM/RR'),TO_DATE('22/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','2','301678',TO_DATE('05/10/20','DD/MM/RR'),TO_DATE('19/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','10','596888',TO_DATE('14/10/20','DD/MM/RR'),TO_DATE('17/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','9','418129',TO_DATE('06/10/20','DD/MM/RR'),TO_DATE('13/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','6','220118',TO_DATE('28/10/20','DD/MM/RR'),TO_DATE('10/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','2','682970',TO_DATE('03/10/20','DD/MM/RR'),TO_DATE('10/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','3','506167',TO_DATE('21/10/20','DD/MM/RR'),TO_DATE('13/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','5','149562',TO_DATE('13/10/20','DD/MM/RR'),TO_DATE('27/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','4','241926',TO_DATE('16/10/20','DD/MM/RR'),TO_DATE('29/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','10','735648',TO_DATE('03/11/20','DD/MM/RR'),TO_DATE('18/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','9','123152',TO_DATE('19/10/20','DD/MM/RR'),TO_DATE('08/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','7','178292',TO_DATE('11/10/20','DD/MM/RR'),TO_DATE('10/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','8','612144',TO_DATE('26/10/20','DD/MM/RR'),TO_DATE('03/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','3','490602',TO_DATE('20/10/20','DD/MM/RR'),TO_DATE('06/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','9','719801',TO_DATE('30/10/20','DD/MM/RR'),TO_DATE('10/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','7','602983',TO_DATE('18/10/20','DD/MM/RR'),TO_DATE('22/11/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','8','123301',TO_DATE('08/11/20','DD/MM/RR'),TO_DATE('13/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','6','667788',TO_DATE('10/11/20','DD/MM/RR'),TO_DATE('14/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','10','839112',TO_DATE('01/11/20','DD/MM/RR'),TO_DATE('12/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','6','386909',TO_DATE('11/11/20','DD/MM/RR'),TO_DATE('20/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','2','743522',TO_DATE('09/11/20','DD/MM/RR'),TO_DATE('03/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','10','441746',TO_DATE('12/11/20','DD/MM/RR'),TO_DATE('15/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','1','172607',TO_DATE('23/10/20','DD/MM/RR'),TO_DATE('04/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','8','349088',TO_DATE('24/10/20','DD/MM/RR'),TO_DATE('06/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','2','754594',TO_DATE('13/11/20','DD/MM/RR'),TO_DATE('24/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','10','712586',TO_DATE('02/11/20','DD/MM/RR'),TO_DATE('25/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','10','122754',TO_DATE('14/11/20','DD/MM/RR'),TO_DATE('16/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','1','532065',TO_DATE('17/11/20','DD/MM/RR'),TO_DATE('01/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','9','578398',TO_DATE('29/10/20','DD/MM/RR'),TO_DATE('07/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','4','519477',TO_DATE('05/11/20','DD/MM/RR'),TO_DATE('29/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','3','690358',TO_DATE('16/11/20','DD/MM/RR'),TO_DATE('29/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','6','212292',TO_DATE('07/11/20','DD/MM/RR'),TO_DATE('02/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','2','689406',TO_DATE('04/11/20','DD/MM/RR'),TO_DATE('04/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','8','365876',TO_DATE('24/11/20','DD/MM/RR'),TO_DATE('25/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','5','224512',TO_DATE('25/11/20','DD/MM/RR'),TO_DATE('19/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','3','138333',TO_DATE('31/10/20','DD/MM/RR'),TO_DATE('26/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','10','616164',TO_DATE('06/11/20','DD/MM/RR'),TO_DATE('20/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','7','221338',TO_DATE('20/11/20','DD/MM/RR'),TO_DATE('07/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','9','575300',TO_DATE('22/11/20','DD/MM/RR'),TO_DATE('07/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','1','575736',TO_DATE('27/11/20','DD/MM/RR'),TO_DATE('15/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','10','419843',TO_DATE('28/11/20','DD/MM/RR'),TO_DATE('08/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','6','593197',TO_DATE('01/12/20','DD/MM/RR'),TO_DATE('23/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','3','172128',TO_DATE('18/11/20','DD/MM/RR'),TO_DATE('04/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','5','214643',TO_DATE('15/11/20','DD/MM/RR'),TO_DATE('09/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','2','240825',TO_DATE('23/11/20','DD/MM/RR'),TO_DATE('21/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','1','885287',TO_DATE('02/12/20','DD/MM/RR'),TO_DATE('26/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','10','108125',TO_DATE('29/11/20','DD/MM/RR'),TO_DATE('17/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','7','347765',TO_DATE('19/11/20','DD/MM/RR'),TO_DATE('13/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','1','188570',TO_DATE('21/11/20','DD/MM/RR'),TO_DATE('09/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','1','271026',TO_DATE('30/11/20','DD/MM/RR'),TO_DATE('22/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','7','672879',TO_DATE('04/12/20','DD/MM/RR'),TO_DATE('04/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','5','704759',TO_DATE('05/12/20','DD/MM/RR'),TO_DATE('23/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','10','605823',TO_DATE('11/12/20','DD/MM/RR'),TO_DATE('19/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','5','302171',TO_DATE('15/12/20','DD/MM/RR'),TO_DATE('08/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','3','541640',TO_DATE('26/11/20','DD/MM/RR'),TO_DATE('30/12/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','3','304586',TO_DATE('09/12/20','DD/MM/RR'),TO_DATE('21/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','2','526348',TO_DATE('06/12/20','DD/MM/RR'),TO_DATE('13/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','2','214841',TO_DATE('07/12/20','DD/MM/RR'),TO_DATE('14/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','10','191736',TO_DATE('13/12/20','DD/MM/RR'),TO_DATE('17/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','5','546783',TO_DATE('03/12/20','DD/MM/RR'),TO_DATE('18/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','2','535719',TO_DATE('16/12/20','DD/MM/RR'),TO_DATE('10/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','140776',TO_DATE('23/12/20','DD/MM/RR'),TO_DATE('06/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','4','751758',TO_DATE('20/12/20','DD/MM/RR'),TO_DATE('20/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','6','560953',TO_DATE('17/12/20','DD/MM/RR'),TO_DATE('19/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','6','497259',TO_DATE('14/12/20','DD/MM/RR'),TO_DATE('21/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','10','191822',TO_DATE('08/12/20','DD/MM/RR'),TO_DATE('28/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','3','667741',TO_DATE('01/01/21','DD/MM/RR'),TO_DATE('17/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','9','228588',TO_DATE('19/12/20','DD/MM/RR'),TO_DATE('01/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','8','241832',TO_DATE('10/12/20','DD/MM/RR'),TO_DATE('31/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','8','373106',TO_DATE('12/12/20','DD/MM/RR'),TO_DATE('15/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','2','597761',TO_DATE('21/12/20','DD/MM/RR'),TO_DATE('21/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','9','772426',TO_DATE('26/12/20','DD/MM/RR'),TO_DATE('23/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','5','124218',TO_DATE('27/12/20','DD/MM/RR'),TO_DATE('25/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','10','656242',TO_DATE('24/12/20','DD/MM/RR'),TO_DATE('30/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','9','832116',TO_DATE('10/01/21','DD/MM/RR'),TO_DATE('10/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','5','699913',TO_DATE('29/12/20','DD/MM/RR'),TO_DATE('07/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','1','141189',TO_DATE('06/01/21','DD/MM/RR'),TO_DATE('21/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','6','468336',TO_DATE('09/01/21','DD/MM/RR'),TO_DATE('16/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','9','894697',TO_DATE('02/01/21','DD/MM/RR'),TO_DATE('09/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','4','383641',TO_DATE('18/12/20','DD/MM/RR'),TO_DATE('31/01/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','5','357070',TO_DATE('28/12/20','DD/MM/RR'),TO_DATE('23/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','10','255229',TO_DATE('12/01/21','DD/MM/RR'),TO_DATE('12/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','3','567136',TO_DATE('15/01/21','DD/MM/RR'),TO_DATE('24/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','9','427592',TO_DATE('07/01/21','DD/MM/RR'),TO_DATE('26/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','2','812541',TO_DATE('11/01/21','DD/MM/RR'),TO_DATE('10/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','8','467425',TO_DATE('16/01/21','DD/MM/RR'),TO_DATE('02/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','6','397653',TO_DATE('22/12/20','DD/MM/RR'),TO_DATE('04/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','2','533608',TO_DATE('09/01/21','DD/MM/RR'),TO_DATE('08/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','5','594247',TO_DATE('02/01/21','DD/MM/RR'),TO_DATE('02/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','3','746182',TO_DATE('03/01/21','DD/MM/RR'),TO_DATE('04/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','2','574687',TO_DATE('25/12/20','DD/MM/RR'),TO_DATE('12/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','4','320690',TO_DATE('30/12/20','DD/MM/RR'),TO_DATE('26/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','5','320016',TO_DATE('14/01/21','DD/MM/RR'),TO_DATE('25/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','3','644176',TO_DATE('19/01/21','DD/MM/RR'),TO_DATE('14/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','8','227835',TO_DATE('13/01/21','DD/MM/RR'),TO_DATE('15/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','9','642486',TO_DATE('04/01/21','DD/MM/RR'),TO_DATE('05/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','8','370277',TO_DATE('19/01/21','DD/MM/RR'),TO_DATE('09/03/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','5','276237',TO_DATE('17/01/21','DD/MM/RR'),TO_DATE('28/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','1','738559',TO_DATE('21/01/21','DD/MM/RR'),TO_DATE('25/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','7','301220',TO_DATE('11/01/21','DD/MM/RR'),TO_DATE('25/02/21','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','9','436865',TO_DATE('13/01/20','DD/MM/RR'),TO_DATE('13/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','1','200135',TO_DATE('29/12/19','DD/MM/RR'),TO_DATE('08/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','6','267026',TO_DATE('31/12/19','DD/MM/RR'),TO_DATE('18/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','7','179702',TO_DATE('23/01/20','DD/MM/RR'),TO_DATE('10/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','9','661170',TO_DATE('16/01/20','DD/MM/RR'),TO_DATE('18/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','2','671717',TO_DATE('25/01/20','DD/MM/RR'),TO_DATE('28/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','5','706407',TO_DATE('12/01/20','DD/MM/RR'),TO_DATE('16/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','6','437353',TO_DATE('21/01/20','DD/MM/RR'),TO_DATE('28/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','1','653032',TO_DATE('27/01/20','DD/MM/RR'),TO_DATE('10/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','2','436675',TO_DATE('10/01/20','DD/MM/RR'),TO_DATE('03/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','8','429530',TO_DATE('01/02/20','DD/MM/RR'),TO_DATE('23/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','9','688273',TO_DATE('06/01/20','DD/MM/RR'),TO_DATE('02/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','2','849318',TO_DATE('04/02/20','DD/MM/RR'),TO_DATE('26/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','10','403433',TO_DATE('26/01/20','DD/MM/RR'),TO_DATE('17/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','7','674295',TO_DATE('20/01/20','DD/MM/RR'),TO_DATE('05/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','7','627341',TO_DATE('22/01/20','DD/MM/RR'),TO_DATE('24/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','2','584588',TO_DATE('03/02/20','DD/MM/RR'),TO_DATE('16/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','5','766785',TO_DATE('28/01/20','DD/MM/RR'),TO_DATE('09/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','5','381767',TO_DATE('18/01/20','DD/MM/RR'),TO_DATE('04/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','7','707302',TO_DATE('16/02/20','DD/MM/RR'),TO_DATE('25/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','6','812269',TO_DATE('29/01/20','DD/MM/RR'),TO_DATE('28/02/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','3','368883',TO_DATE('24/01/20','DD/MM/RR'),TO_DATE('18/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','6','334189',TO_DATE('30/01/20','DD/MM/RR'),TO_DATE('28/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','7','109199',TO_DATE('17/02/20','DD/MM/RR'),TO_DATE('20/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','1','172429',TO_DATE('21/02/20','DD/MM/RR'),TO_DATE('20/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','4','655853',TO_DATE('31/01/20','DD/MM/RR'),TO_DATE('09/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','10','383435',TO_DATE('24/02/20','DD/MM/RR'),TO_DATE('05/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','4','707499',TO_DATE('11/02/20','DD/MM/RR'),TO_DATE('28/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','8','359140',TO_DATE('05/02/20','DD/MM/RR'),TO_DATE('26/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','3','127144',TO_DATE('02/02/20','DD/MM/RR'),TO_DATE('30/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','3','690682',TO_DATE('09/02/20','DD/MM/RR'),TO_DATE('20/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','2','769625',TO_DATE('14/02/20','DD/MM/RR'),TO_DATE('04/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','8','708196',TO_DATE('10/02/20','DD/MM/RR'),TO_DATE('22/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','10','720636',TO_DATE('13/02/20','DD/MM/RR'),TO_DATE('19/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','10','534542',TO_DATE('19/02/20','DD/MM/RR'),TO_DATE('31/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','1','606863',TO_DATE('12/02/20','DD/MM/RR'),TO_DATE('13/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','8','729764',TO_DATE('08/02/20','DD/MM/RR'),TO_DATE('13/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','3','890133',TO_DATE('06/02/20','DD/MM/RR'),TO_DATE('29/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','2','309249',TO_DATE('28/02/20','DD/MM/RR'),TO_DATE('01/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','9','181158',TO_DATE('05/03/20','DD/MM/RR'),TO_DATE('03/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','5','109758',TO_DATE('07/02/20','DD/MM/RR'),TO_DATE('29/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','3','359482',TO_DATE('15/02/20','DD/MM/RR'),TO_DATE('21/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','10','217709',TO_DATE('18/02/20','DD/MM/RR'),TO_DATE('23/03/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','7','863886',TO_DATE('25/02/20','DD/MM/RR'),TO_DATE('24/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','3','757163',TO_DATE('23/02/20','DD/MM/RR'),TO_DATE('18/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','5','209474',TO_DATE('27/02/20','DD/MM/RR'),TO_DATE('13/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','9','638735',TO_DATE('20/02/20','DD/MM/RR'),TO_DATE('02/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','1','162303',TO_DATE('22/02/20','DD/MM/RR'),TO_DATE('16/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','5','513237',TO_DATE('07/03/20','DD/MM/RR'),TO_DATE('23/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','10','504259',TO_DATE('11/03/20','DD/MM/RR'),TO_DATE('20/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','2','532338',TO_DATE('10/03/20','DD/MM/RR'),TO_DATE('19/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','4','130170',TO_DATE('14/03/20','DD/MM/RR'),TO_DATE('12/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','4','560727',TO_DATE('18/03/20','DD/MM/RR'),TO_DATE('06/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','8','456302',TO_DATE('02/03/20','DD/MM/RR'),TO_DATE('20/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','3','337590',TO_DATE('01/03/20','DD/MM/RR'),TO_DATE('09/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','3','301780',TO_DATE('28/02/20','DD/MM/RR'),TO_DATE('25/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','3','551335',TO_DATE('06/03/20','DD/MM/RR'),TO_DATE('14/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','9','283008',TO_DATE('13/03/20','DD/MM/RR'),TO_DATE('21/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','2','304246',TO_DATE('22/03/20','DD/MM/RR'),TO_DATE('20/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','1','697968',TO_DATE('26/02/20','DD/MM/RR'),TO_DATE('22/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','9','300791',TO_DATE('03/03/20','DD/MM/RR'),TO_DATE('08/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','6','743938',TO_DATE('16/03/20','DD/MM/RR'),TO_DATE('13/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','2','501222',TO_DATE('04/03/20','DD/MM/RR'),TO_DATE('18/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','2','677862',TO_DATE('19/03/20','DD/MM/RR'),TO_DATE('22/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','6','610136',TO_DATE('28/03/20','DD/MM/RR'),TO_DATE('19/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','7','147241',TO_DATE('20/03/20','DD/MM/RR'),TO_DATE('16/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','10','373927',TO_DATE('09/03/20','DD/MM/RR'),TO_DATE('03/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','1','706020',TO_DATE('12/03/20','DD/MM/RR'),TO_DATE('06/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','7','341075',TO_DATE('23/03/20','DD/MM/RR'),TO_DATE('26/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','9','181659',TO_DATE('21/03/20','DD/MM/RR'),TO_DATE('05/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','2','469896',TO_DATE('17/03/20','DD/MM/RR'),TO_DATE('12/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','4','194072',TO_DATE('25/03/20','DD/MM/RR'),TO_DATE('19/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','3','103052',TO_DATE('08/03/20','DD/MM/RR'),TO_DATE('03/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','9','673323',TO_DATE('26/03/20','DD/MM/RR'),TO_DATE('17/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','4','687028',TO_DATE('15/03/20','DD/MM/RR'),TO_DATE('22/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','2','567228',TO_DATE('11/04/20','DD/MM/RR'),TO_DATE('22/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','6','683050',TO_DATE('29/03/20','DD/MM/RR'),TO_DATE('08/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','8','683591',TO_DATE('27/03/20','DD/MM/RR'),TO_DATE('02/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','6','435720',TO_DATE('05/04/20','DD/MM/RR'),TO_DATE('29/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','6','270992',TO_DATE('03/04/20','DD/MM/RR'),TO_DATE('25/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','10','761862',TO_DATE('16/04/20','DD/MM/RR'),TO_DATE('22/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','3','781045',TO_DATE('14/04/20','DD/MM/RR'),TO_DATE('31/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','1','452217',TO_DATE('15/04/20','DD/MM/RR'),TO_DATE('28/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','7','374927',TO_DATE('02/04/20','DD/MM/RR'),TO_DATE('22/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','309659',TO_DATE('04/04/20','DD/MM/RR'),TO_DATE('02/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','1','844092',TO_DATE('08/04/20','DD/MM/RR'),TO_DATE('18/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','3','323904',TO_DATE('12/04/20','DD/MM/RR'),TO_DATE('08/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','2','395188',TO_DATE('24/03/20','DD/MM/RR'),TO_DATE('24/04/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','3','451936',TO_DATE('01/04/20','DD/MM/RR'),TO_DATE('28/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','3','584103',TO_DATE('22/04/20','DD/MM/RR'),TO_DATE('01/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','6','772492',TO_DATE('09/04/20','DD/MM/RR'),TO_DATE('14/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','1','164912',TO_DATE('18/04/20','DD/MM/RR'),TO_DATE('16/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','1','639295',TO_DATE('24/04/20','DD/MM/RR'),TO_DATE('17/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','3','310562',TO_DATE('31/03/20','DD/MM/RR'),TO_DATE('09/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','3','692490',TO_DATE('30/03/20','DD/MM/RR'),TO_DATE('19/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','1','738823',TO_DATE('10/04/20','DD/MM/RR'),TO_DATE('20/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','4','346915',TO_DATE('01/05/20','DD/MM/RR'),TO_DATE('14/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','3','633319',TO_DATE('17/04/20','DD/MM/RR'),TO_DATE('27/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','3','571318',TO_DATE('02/05/20','DD/MM/RR'),TO_DATE('23/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','2','191191',TO_DATE('19/04/20','DD/MM/RR'),TO_DATE('06/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','4','302163',TO_DATE('27/04/20','DD/MM/RR'),TO_DATE('08/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','9','499147',TO_DATE('20/04/20','DD/MM/RR'),TO_DATE('13/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','6','836101',TO_DATE('06/04/20','DD/MM/RR'),TO_DATE('22/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','5','806764',TO_DATE('28/04/20','DD/MM/RR'),TO_DATE('24/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','7','871208',TO_DATE('07/04/20','DD/MM/RR'),TO_DATE('09/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','3','649963',TO_DATE('29/04/20','DD/MM/RR'),TO_DATE('07/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','10','654559',TO_DATE('13/04/20','DD/MM/RR'),TO_DATE('27/05/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','9','462347',TO_DATE('06/05/20','DD/MM/RR'),TO_DATE('27/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','7','638273',TO_DATE('11/05/20','DD/MM/RR'),TO_DATE('25/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','4','516077',TO_DATE('13/05/20','DD/MM/RR'),TO_DATE('19/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','4','520241',TO_DATE('17/05/20','DD/MM/RR'),TO_DATE('29/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','5','779737',TO_DATE('26/04/20','DD/MM/RR'),TO_DATE('19/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','7','824742',TO_DATE('16/05/20','DD/MM/RR'),TO_DATE('01/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','870991',TO_DATE('30/04/20','DD/MM/RR'),TO_DATE('10/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','6','555539',TO_DATE('14/05/20','DD/MM/RR'),TO_DATE('19/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','10','405282',TO_DATE('07/05/20','DD/MM/RR'),TO_DATE('24/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','6','327824',TO_DATE('22/04/20','DD/MM/RR'),TO_DATE('18/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','2','323413',TO_DATE('21/04/20','DD/MM/RR'),TO_DATE('14/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','7','700295',TO_DATE('25/04/20','DD/MM/RR'),TO_DATE('20/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','5','143904',TO_DATE('15/05/20','DD/MM/RR'),TO_DATE('03/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','3','755799',TO_DATE('09/05/20','DD/MM/RR'),TO_DATE('19/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','9','745010',TO_DATE('23/05/20','DD/MM/RR'),TO_DATE('08/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','4','731558',TO_DATE('12/05/20','DD/MM/RR'),TO_DATE('16/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','8','583282',TO_DATE('04/05/20','DD/MM/RR'),TO_DATE('14/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','10','147190',TO_DATE('05/05/20','DD/MM/RR'),TO_DATE('29/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','2','636411',TO_DATE('10/05/20','DD/MM/RR'),TO_DATE('01/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','6','849711',TO_DATE('03/05/20','DD/MM/RR'),TO_DATE('01/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','5','170049',TO_DATE('27/05/20','DD/MM/RR'),TO_DATE('27/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','4','712467',TO_DATE('31/05/20','DD/MM/RR'),TO_DATE('06/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','9','163610',TO_DATE('08/05/20','DD/MM/RR'),TO_DATE('12/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','5','180880',TO_DATE('30/05/20','DD/MM/RR'),TO_DATE('07/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','4','282022',TO_DATE('29/05/20','DD/MM/RR'),TO_DATE('10/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','1','537801',TO_DATE('20/05/20','DD/MM/RR'),TO_DATE('19/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','5','450707',TO_DATE('03/06/20','DD/MM/RR'),TO_DATE('02/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','1','341040',TO_DATE('19/05/20','DD/MM/RR'),TO_DATE('23/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','3','766960',TO_DATE('24/05/20','DD/MM/RR'),TO_DATE('03/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','6','237697',TO_DATE('18/05/20','DD/MM/RR'),TO_DATE('25/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','1','130384',TO_DATE('21/05/20','DD/MM/RR'),TO_DATE('13/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','3','524024',TO_DATE('22/05/20','DD/MM/RR'),TO_DATE('30/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','5','668450',TO_DATE('11/06/20','DD/MM/RR'),TO_DATE('26/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','1','513304',TO_DATE('26/05/20','DD/MM/RR'),TO_DATE('03/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','2','604431',TO_DATE('02/06/20','DD/MM/RR'),TO_DATE('22/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','5','722279',TO_DATE('06/06/20','DD/MM/RR'),TO_DATE('13/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','10','202366',TO_DATE('28/05/20','DD/MM/RR'),TO_DATE('21/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','6','439265',TO_DATE('12/06/20','DD/MM/RR'),TO_DATE('21/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','9','522436',TO_DATE('18/06/20','DD/MM/RR'),TO_DATE('26/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','8','524926',TO_DATE('15/06/20','DD/MM/RR'),TO_DATE('24/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','6','287367',TO_DATE('25/05/20','DD/MM/RR'),TO_DATE('28/06/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','3','160555',TO_DATE('14/06/20','DD/MM/RR'),TO_DATE('06/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','632663',TO_DATE('01/06/20','DD/MM/RR'),TO_DATE('22/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','4','246036',TO_DATE('07/06/20','DD/MM/RR'),TO_DATE('08/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','8','288841',TO_DATE('24/06/20','DD/MM/RR'),TO_DATE('02/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','6','142513',TO_DATE('27/06/20','DD/MM/RR'),TO_DATE('09/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','2','806142',TO_DATE('09/06/20','DD/MM/RR'),TO_DATE('22/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','8','845766',TO_DATE('20/06/20','DD/MM/RR'),TO_DATE('12/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','3','857320',TO_DATE('21/06/20','DD/MM/RR'),TO_DATE('24/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','8','411738',TO_DATE('08/06/20','DD/MM/RR'),TO_DATE('18/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','3','439940',TO_DATE('19/06/20','DD/MM/RR'),TO_DATE('12/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','7','881210',TO_DATE('01/07/20','DD/MM/RR'),TO_DATE('16/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','4','833502',TO_DATE('10/06/20','DD/MM/RR'),TO_DATE('04/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','8','757433',TO_DATE('05/06/20','DD/MM/RR'),TO_DATE('31/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','7','449434',TO_DATE('04/06/20','DD/MM/RR'),TO_DATE('07/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','6','723459',TO_DATE('05/07/20','DD/MM/RR'),TO_DATE('09/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','9','281161',TO_DATE('02/07/20','DD/MM/RR'),TO_DATE('29/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','10','448653',TO_DATE('13/06/20','DD/MM/RR'),TO_DATE('23/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','4','411768',TO_DATE('23/06/20','DD/MM/RR'),TO_DATE('27/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','3','517379',TO_DATE('08/07/20','DD/MM/RR'),TO_DATE('13/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','7','477601',TO_DATE('26/06/20','DD/MM/RR'),TO_DATE('07/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','4','421311',TO_DATE('25/06/20','DD/MM/RR'),TO_DATE('23/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','3','198469',TO_DATE('13/07/20','DD/MM/RR'),TO_DATE('17/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','3','637438',TO_DATE('16/06/20','DD/MM/RR'),TO_DATE('01/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','1','761008',TO_DATE('22/06/20','DD/MM/RR'),TO_DATE('26/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','6','246867',TO_DATE('16/07/20','DD/MM/RR'),TO_DATE('16/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','5','649763',TO_DATE('17/06/20','DD/MM/RR'),TO_DATE('30/07/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','3','333807',TO_DATE('15/07/20','DD/MM/RR'),TO_DATE('03/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','7','506292',TO_DATE('28/06/20','DD/MM/RR'),TO_DATE('10/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','1','672433',TO_DATE('29/06/20','DD/MM/RR'),TO_DATE('23/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','1','813253',TO_DATE('11/07/20','DD/MM/RR'),TO_DATE('19/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','3','278895',TO_DATE('30/06/20','DD/MM/RR'),TO_DATE('06/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','10','436431',TO_DATE('04/07/20','DD/MM/RR'),TO_DATE('23/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','6','506771',TO_DATE('24/07/20','DD/MM/RR'),TO_DATE('12/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','6','536281',TO_DATE('09/07/20','DD/MM/RR'),TO_DATE('02/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','8','451037',TO_DATE('14/07/20','DD/MM/RR'),TO_DATE('01/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','5','128772',TO_DATE('22/07/20','DD/MM/RR'),TO_DATE('01/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','1','529045',TO_DATE('06/07/20','DD/MM/RR'),TO_DATE('14/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','10','854595',TO_DATE('12/07/20','DD/MM/RR'),TO_DATE('21/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','7','527004',TO_DATE('29/07/20','DD/MM/RR'),TO_DATE('21/09/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','3','382376',TO_DATE('03/07/20','DD/MM/RR'),TO_DATE('17/08/20','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','3','109878',TO_DATE('23/01/19','DD/MM/RR'),TO_DATE('22/02/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','3','247121',TO_DATE('27/01/19','DD/MM/RR'),TO_DATE('08/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','2','416566',TO_DATE('26/01/19','DD/MM/RR'),TO_DATE('26/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','7','647385',TO_DATE('31/01/19','DD/MM/RR'),TO_DATE('06/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','1','466289',TO_DATE('08/02/19','DD/MM/RR'),TO_DATE('10/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','6','885871',TO_DATE('20/02/19','DD/MM/RR'),TO_DATE('25/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','1','587167',TO_DATE('19/02/19','DD/MM/RR'),TO_DATE('13/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','8','278677',TO_DATE('22/02/19','DD/MM/RR'),TO_DATE('03/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','5','476640',TO_DATE('11/02/19','DD/MM/RR'),TO_DATE('10/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','2','244554',TO_DATE('21/02/19','DD/MM/RR'),TO_DATE('07/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','7','492271',TO_DATE('10/02/19','DD/MM/RR'),TO_DATE('02/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','10','216437',TO_DATE('03/02/19','DD/MM/RR'),TO_DATE('15/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','9','719263',TO_DATE('04/02/19','DD/MM/RR'),TO_DATE('27/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','10','895349',TO_DATE('27/02/19','DD/MM/RR'),TO_DATE('11/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','9','480273',TO_DATE('18/02/19','DD/MM/RR'),TO_DATE('20/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','2','284944',TO_DATE('25/02/19','DD/MM/RR'),TO_DATE('27/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','3','103753',TO_DATE('06/02/19','DD/MM/RR'),TO_DATE('16/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','3','317328',TO_DATE('05/02/19','DD/MM/RR'),TO_DATE('29/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','10','472852',TO_DATE('28/02/19','DD/MM/RR'),TO_DATE('29/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','6','340696',TO_DATE('24/02/19','DD/MM/RR'),TO_DATE('31/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','9','684876',TO_DATE('09/02/19','DD/MM/RR'),TO_DATE('11/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','1','236610',TO_DATE('14/02/19','DD/MM/RR'),TO_DATE('31/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','6','393311',TO_DATE('03/03/19','DD/MM/RR'),TO_DATE('04/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','3','485748',TO_DATE('02/03/19','DD/MM/RR'),TO_DATE('21/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','9','231408',TO_DATE('14/03/19','DD/MM/RR'),TO_DATE('15/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','1','645714',TO_DATE('17/02/19','DD/MM/RR'),TO_DATE('29/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','5','834607',TO_DATE('15/03/19','DD/MM/RR'),TO_DATE('17/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','5','489730',TO_DATE('26/02/19','DD/MM/RR'),TO_DATE('12/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','6','148590',TO_DATE('01/03/19','DD/MM/RR'),TO_DATE('12/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','3','585322',TO_DATE('05/03/19','DD/MM/RR'),TO_DATE('25/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','6','141224',TO_DATE('16/02/19','DD/MM/RR'),TO_DATE('28/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','3','134360',TO_DATE('07/03/19','DD/MM/RR'),TO_DATE('16/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','5','462449',TO_DATE('11/03/19','DD/MM/RR'),TO_DATE('11/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','6','741460',TO_DATE('23/02/19','DD/MM/RR'),TO_DATE('17/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','9','855486',TO_DATE('12/03/19','DD/MM/RR'),TO_DATE('15/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','10','442863',TO_DATE('19/03/19','DD/MM/RR'),TO_DATE('22/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','10','386546',TO_DATE('04/03/19','DD/MM/RR'),TO_DATE('30/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','6','480355',TO_DATE('09/03/19','DD/MM/RR'),TO_DATE('23/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','9','882987',TO_DATE('18/03/19','DD/MM/RR'),TO_DATE('30/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','2','573084',TO_DATE('28/03/19','DD/MM/RR'),TO_DATE('08/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','1','467388',TO_DATE('21/03/19','DD/MM/RR'),TO_DATE('30/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','8','455327',TO_DATE('29/03/19','DD/MM/RR'),TO_DATE('06/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','4','374400',TO_DATE('08/03/19','DD/MM/RR'),TO_DATE('11/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','10','156720',TO_DATE('10/03/19','DD/MM/RR'),TO_DATE('01/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','9','269639',TO_DATE('06/03/19','DD/MM/RR'),TO_DATE('01/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','6','136269',TO_DATE('16/03/19','DD/MM/RR'),TO_DATE('03/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','3','206786',TO_DATE('23/03/19','DD/MM/RR'),TO_DATE('28/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','6','365133',TO_DATE('25/03/19','DD/MM/RR'),TO_DATE('09/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','10','720063',TO_DATE('24/03/19','DD/MM/RR'),TO_DATE('23/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','10','534798',TO_DATE('02/04/19','DD/MM/RR'),TO_DATE('20/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','9','264920',TO_DATE('13/03/19','DD/MM/RR'),TO_DATE('03/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','7','641415',TO_DATE('17/03/19','DD/MM/RR'),TO_DATE('13/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','8','658441',TO_DATE('22/03/19','DD/MM/RR'),TO_DATE('07/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','2','433353',TO_DATE('10/04/19','DD/MM/RR'),TO_DATE('26/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','6','617724',TO_DATE('13/04/19','DD/MM/RR'),TO_DATE('06/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','6','697325',TO_DATE('27/03/19','DD/MM/RR'),TO_DATE('20/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','5','576880',TO_DATE('04/04/19','DD/MM/RR'),TO_DATE('03/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','9','676590',TO_DATE('20/03/19','DD/MM/RR'),TO_DATE('03/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','8','498794',TO_DATE('30/03/19','DD/MM/RR'),TO_DATE('10/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','3','628401',TO_DATE('31/03/19','DD/MM/RR'),TO_DATE('23/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','3','484636',TO_DATE('15/04/19','DD/MM/RR'),TO_DATE('04/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','2','848901',TO_DATE('03/04/19','DD/MM/RR'),TO_DATE('29/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','8','469385',TO_DATE('06/04/19','DD/MM/RR'),TO_DATE('19/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','4','728906',TO_DATE('07/04/19','DD/MM/RR'),TO_DATE('20/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','2','561970',TO_DATE('08/04/19','DD/MM/RR'),TO_DATE('22/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','7','486435',TO_DATE('01/04/19','DD/MM/RR'),TO_DATE('12/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','1','875484',TO_DATE('05/04/19','DD/MM/RR'),TO_DATE('11/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','4','356526',TO_DATE('11/04/19','DD/MM/RR'),TO_DATE('24/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','10','266770',TO_DATE('14/04/19','DD/MM/RR'),TO_DATE('29/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','4','418149',TO_DATE('26/03/19','DD/MM/RR'),TO_DATE('13/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','1','679199',TO_DATE('09/04/19','DD/MM/RR'),TO_DATE('16/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','1','454648',TO_DATE('28/04/19','DD/MM/RR'),TO_DATE('30/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','10','542876',TO_DATE('16/04/19','DD/MM/RR'),TO_DATE('23/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','9','645906',TO_DATE('12/04/19','DD/MM/RR'),TO_DATE('24/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','8','857928',TO_DATE('22/04/19','DD/MM/RR'),TO_DATE('15/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','6','631015',TO_DATE('17/04/19','DD/MM/RR'),TO_DATE('21/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','9','552949',TO_DATE('19/04/19','DD/MM/RR'),TO_DATE('23/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','7','815183',TO_DATE('20/04/19','DD/MM/RR'),TO_DATE('06/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','7','737943',TO_DATE('30/04/19','DD/MM/RR'),TO_DATE('24/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','4','173142',TO_DATE('02/05/19','DD/MM/RR'),TO_DATE('09/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','3','184016',TO_DATE('21/04/19','DD/MM/RR'),TO_DATE('21/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','4','543518',TO_DATE('27/04/19','DD/MM/RR'),TO_DATE('28/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','8','842170',TO_DATE('08/05/19','DD/MM/RR'),TO_DATE('02/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','9','397550',TO_DATE('26/04/19','DD/MM/RR'),TO_DATE('08/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','4','735379',TO_DATE('07/05/19','DD/MM/RR'),TO_DATE('12/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','8','538838',TO_DATE('23/04/19','DD/MM/RR'),TO_DATE('29/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','4','410330',TO_DATE('04/05/19','DD/MM/RR'),TO_DATE('23/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','2','834103',TO_DATE('29/04/19','DD/MM/RR'),TO_DATE('20/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','2','590455',TO_DATE('18/04/19','DD/MM/RR'),TO_DATE('26/05/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','3','660899',TO_DATE('24/04/19','DD/MM/RR'),TO_DATE('04/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','2','142091',TO_DATE('17/05/19','DD/MM/RR'),TO_DATE('25/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','8','856746',TO_DATE('05/05/19','DD/MM/RR'),TO_DATE('01/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','6','350822',TO_DATE('11/05/19','DD/MM/RR'),TO_DATE('16/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','3','832365',TO_DATE('14/05/19','DD/MM/RR'),TO_DATE('11/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','297175',TO_DATE('25/04/19','DD/MM/RR'),TO_DATE('11/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','9','548303',TO_DATE('01/05/19','DD/MM/RR'),TO_DATE('17/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','9','701047',TO_DATE('10/05/19','DD/MM/RR'),TO_DATE('22/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','10','816892',TO_DATE('19/05/19','DD/MM/RR'),TO_DATE('17/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','2','468046',TO_DATE('22/05/19','DD/MM/RR'),TO_DATE('24/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','4','115292',TO_DATE('03/05/19','DD/MM/RR'),TO_DATE('24/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','2','310207',TO_DATE('25/05/19','DD/MM/RR'),TO_DATE('24/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','4','816109',TO_DATE('30/05/19','DD/MM/RR'),TO_DATE('01/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','4','694749',TO_DATE('09/05/19','DD/MM/RR'),TO_DATE('02/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','1','773341',TO_DATE('02/06/19','DD/MM/RR'),TO_DATE('05/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','1','670337',TO_DATE('23/05/19','DD/MM/RR'),TO_DATE('16/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','4','113269',TO_DATE('06/05/19','DD/MM/RR'),TO_DATE('02/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','2','556940',TO_DATE('16/05/19','DD/MM/RR'),TO_DATE('17/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','8','847501',TO_DATE('29/05/19','DD/MM/RR'),TO_DATE('21/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','10','597704',TO_DATE('24/05/19','DD/MM/RR'),TO_DATE('27/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','5','899473',TO_DATE('26/05/19','DD/MM/RR'),TO_DATE('29/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','4','664179',TO_DATE('15/05/19','DD/MM/RR'),TO_DATE('02/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','3','191101',TO_DATE('12/05/19','DD/MM/RR'),TO_DATE('08/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','5','721790',TO_DATE('10/06/19','DD/MM/RR'),TO_DATE('08/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','9','394853',TO_DATE('18/05/19','DD/MM/RR'),TO_DATE('29/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7168526','10','698378',TO_DATE('28/05/19','DD/MM/RR'),TO_DATE('04/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','4','461967',TO_DATE('14/05/19','DD/MM/RR'),TO_DATE('09/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','7','314921',TO_DATE('14/06/19','DD/MM/RR'),TO_DATE('22/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','6','391407',TO_DATE('05/06/19','DD/MM/RR'),TO_DATE('22/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','4','336686',TO_DATE('21/05/19','DD/MM/RR'),TO_DATE('17/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','10','368519',TO_DATE('20/05/19','DD/MM/RR'),TO_DATE('20/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','3','253229',TO_DATE('12/06/19','DD/MM/RR'),TO_DATE('23/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','1','276947',TO_DATE('07/06/19','DD/MM/RR'),TO_DATE('24/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','4','557340',TO_DATE('31/05/19','DD/MM/RR'),TO_DATE('11/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','9','840073',TO_DATE('06/06/19','DD/MM/RR'),TO_DATE('16/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','8','163991',TO_DATE('17/06/19','DD/MM/RR'),TO_DATE('01/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','9','722704',TO_DATE('03/06/19','DD/MM/RR'),TO_DATE('12/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','5','354889',TO_DATE('04/06/19','DD/MM/RR'),TO_DATE('13/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','9','839713',TO_DATE('27/05/19','DD/MM/RR'),TO_DATE('26/06/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','10','813430',TO_DATE('18/06/19','DD/MM/RR'),TO_DATE('28/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','1','279466',TO_DATE('08/06/19','DD/MM/RR'),TO_DATE('01/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','5','840583',TO_DATE('22/06/19','DD/MM/RR'),TO_DATE('07/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','7','819848',TO_DATE('11/06/19','DD/MM/RR'),TO_DATE('31/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6269943','2','724525',TO_DATE('23/06/19','DD/MM/RR'),TO_DATE('08/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','4','481728',TO_DATE('01/06/19','DD/MM/RR'),TO_DATE('26/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','2','501056',TO_DATE('19/06/19','DD/MM/RR'),TO_DATE('07/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','9','404420',TO_DATE('09/06/19','DD/MM/RR'),TO_DATE('16/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','4','744453',TO_DATE('01/07/19','DD/MM/RR'),TO_DATE('25/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18835559','10','219567',TO_DATE('02/07/19','DD/MM/RR'),TO_DATE('15/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','1','504484',TO_DATE('13/06/19','DD/MM/RR'),TO_DATE('28/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16874219','10','837868',TO_DATE('07/07/19','DD/MM/RR'),TO_DATE('20/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','9','657780',TO_DATE('24/06/19','DD/MM/RR'),TO_DATE('16/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','10','773493',TO_DATE('10/07/19','DD/MM/RR'),TO_DATE('05/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','2','354238',TO_DATE('29/06/19','DD/MM/RR'),TO_DATE('07/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','1','525330',TO_DATE('20/06/19','DD/MM/RR'),TO_DATE('19/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','6','473237',TO_DATE('26/06/19','DD/MM/RR'),TO_DATE('16/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','9','422933',TO_DATE('15/06/19','DD/MM/RR'),TO_DATE('29/07/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','5','159159',TO_DATE('18/06/19','DD/MM/RR'),TO_DATE('14/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18804511','1','704849',TO_DATE('28/06/19','DD/MM/RR'),TO_DATE('27/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19567994','8','813520',TO_DATE('16/07/19','DD/MM/RR'),TO_DATE('14/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','2','158867',TO_DATE('21/06/19','DD/MM/RR'),TO_DATE('10/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','2','263498',TO_DATE('05/07/19','DD/MM/RR'),TO_DATE('27/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','2','628545',TO_DATE('27/06/19','DD/MM/RR'),TO_DATE('02/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','4','732010',TO_DATE('30/06/19','DD/MM/RR'),TO_DATE('06/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19100598','2','143532',TO_DATE('08/07/19','DD/MM/RR'),TO_DATE('07/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17067642','2','899556',TO_DATE('09/07/19','DD/MM/RR'),TO_DATE('15/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','3','652672',TO_DATE('05/01/19','DD/MM/RR'),TO_DATE('10/02/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','1','252001',TO_DATE('04/01/19','DD/MM/RR'),TO_DATE('22/02/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','8','333619',TO_DATE('02/01/19','DD/MM/RR'),TO_DATE('28/02/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','10','152872',TO_DATE('07/01/19','DD/MM/RR'),TO_DATE('12/02/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','7','487661',TO_DATE('11/01/19','DD/MM/RR'),TO_DATE('12/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','6','751179',TO_DATE('19/01/19','DD/MM/RR'),TO_DATE('01/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','9','564085',TO_DATE('18/01/19','DD/MM/RR'),TO_DATE('28/02/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','9','231760',TO_DATE('15/01/19','DD/MM/RR'),TO_DATE('08/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16641880','1','186399',TO_DATE('30/01/19','DD/MM/RR'),TO_DATE('20/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','8','567673',TO_DATE('04/01/19','DD/MM/RR'),TO_DATE('26/02/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','5','895507',TO_DATE('06/01/19','DD/MM/RR'),TO_DATE('07/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','10','194767',TO_DATE('16/01/19','DD/MM/RR'),TO_DATE('07/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7744083','9','390112',TO_DATE('24/01/19','DD/MM/RR'),TO_DATE('02/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18550492','4','398022',TO_DATE('25/01/19','DD/MM/RR'),TO_DATE('24/02/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','9','106590',TO_DATE('09/01/19','DD/MM/RR'),TO_DATE('10/02/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','9','483142',TO_DATE('08/01/19','DD/MM/RR'),TO_DATE('01/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7503210','1','562426',TO_DATE('22/01/19','DD/MM/RR'),TO_DATE('23/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6756480','5','506388',TO_DATE('10/01/19','DD/MM/RR'),TO_DATE('01/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','2','812053',TO_DATE('21/01/19','DD/MM/RR'),TO_DATE('01/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','2','552691',TO_DATE('02/02/19','DD/MM/RR'),TO_DATE('14/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','8','634887',TO_DATE('12/01/19','DD/MM/RR'),TO_DATE('13/02/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16690718','8','177412',TO_DATE('01/02/19','DD/MM/RR'),TO_DATE('25/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18352172','5','336882',TO_DATE('17/01/19','DD/MM/RR'),TO_DATE('01/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','2','256675',TO_DATE('14/01/19','DD/MM/RR'),TO_DATE('02/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','5','215984',TO_DATE('13/01/19','DD/MM/RR'),TO_DATE('16/02/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16809546','6','630883',TO_DATE('07/02/19','DD/MM/RR'),TO_DATE('08/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18699786','7','602330',TO_DATE('29/01/19','DD/MM/RR'),TO_DATE('26/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','9','221471',TO_DATE('15/02/19','DD/MM/RR'),TO_DATE('16/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7284220','8','636562',TO_DATE('20/01/19','DD/MM/RR'),TO_DATE('06/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','10','290520',TO_DATE('13/02/19','DD/MM/RR'),TO_DATE('11/04/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','5','875929',TO_DATE('28/01/19','DD/MM/RR'),TO_DATE('26/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19120175','6','659130',TO_DATE('12/02/19','DD/MM/RR'),TO_DATE('17/03/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18839556','5','137847',TO_DATE('04/07/19','DD/MM/RR'),TO_DATE('23/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','3','598771',TO_DATE('17/07/19','DD/MM/RR'),TO_DATE('18/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','2','626772',TO_DATE('25/06/19','DD/MM/RR'),TO_DATE('08/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19303268','4','267123',TO_DATE('12/07/19','DD/MM/RR'),TO_DATE('21/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18934168','4','729255',TO_DATE('06/07/19','DD/MM/RR'),TO_DATE('24/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17264208','6','208769',TO_DATE('21/07/19','DD/MM/RR'),TO_DATE('27/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19435555','8','770313',TO_DATE('14/07/19','DD/MM/RR'),TO_DATE('27/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19664729','7','730954',TO_DATE('22/07/19','DD/MM/RR'),TO_DATE('05/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('16764496','9','772749',TO_DATE('03/07/19','DD/MM/RR'),TO_DATE('20/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17233467','5','410868',TO_DATE('13/07/19','DD/MM/RR'),TO_DATE('05/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17393265','3','786645',TO_DATE('20/07/19','DD/MM/RR'),TO_DATE('15/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17511566','3','138308',TO_DATE('25/07/19','DD/MM/RR'),TO_DATE('16/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','9','884725',TO_DATE('03/08/19','DD/MM/RR'),TO_DATE('16/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19743237','3','768622',TO_DATE('24/07/19','DD/MM/RR'),TO_DATE('20/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19816444','7','676142',TO_DATE('30/07/19','DD/MM/RR'),TO_DATE('05/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19633374','10','462177',TO_DATE('18/07/19','DD/MM/RR'),TO_DATE('30/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17204426','7','832603',TO_DATE('11/07/19','DD/MM/RR'),TO_DATE('12/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17723898','4','893062',TO_DATE('02/08/19','DD/MM/RR'),TO_DATE('01/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6057969','5','793524',TO_DATE('27/07/19','DD/MM/RR'),TO_DATE('10/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17237023','8','150379',TO_DATE('15/07/19','DD/MM/RR'),TO_DATE('04/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','1','434535',TO_DATE('04/08/19','DD/MM/RR'),TO_DATE('19/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19639001','5','723245',TO_DATE('20/07/19','DD/MM/RR'),TO_DATE('07/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19796164','8','851483',TO_DATE('28/07/19','DD/MM/RR'),TO_DATE('15/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17889317','3','785370',TO_DATE('12/08/19','DD/MM/RR'),TO_DATE('14/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17598097','2','264748',TO_DATE('29/07/19','DD/MM/RR'),TO_DATE('06/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19770211','7','454494',TO_DATE('26/07/19','DD/MM/RR'),TO_DATE('22/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17467536','3','502984',TO_DATE('23/07/19','DD/MM/RR'),TO_DATE('31/08/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6506702','10','750087',TO_DATE('09/08/19','DD/MM/RR'),TO_DATE('16/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','1','860345',TO_DATE('05/08/19','DD/MM/RR'),TO_DATE('03/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18280709','2','455003',TO_DATE('16/08/19','DD/MM/RR'),TO_DATE('14/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18336158','3','365384',TO_DATE('18/08/19','DD/MM/RR'),TO_DATE('01/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','10','233684',TO_DATE('07/08/19','DD/MM/RR'),TO_DATE('28/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17814206','9','117331',TO_DATE('10/08/19','DD/MM/RR'),TO_DATE('09/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('7034898','9','226910',TO_DATE('15/08/19','DD/MM/RR'),TO_DATE('30/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17604208','6','225522',TO_DATE('31/07/19','DD/MM/RR'),TO_DATE('15/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6502066','7','232172',TO_DATE('23/08/19','DD/MM/RR'),TO_DATE('30/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18421225','8','259086',TO_DATE('24/08/19','DD/MM/RR'),TO_DATE('19/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6946767','6','251135',TO_DATE('13/08/19','DD/MM/RR'),TO_DATE('07/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('19987871','10','795945',TO_DATE('01/08/19','DD/MM/RR'),TO_DATE('09/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','9','461423',TO_DATE('14/08/19','DD/MM/RR'),TO_DATE('17/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17817690','8','393959',TO_DATE('06/08/19','DD/MM/RR'),TO_DATE('01/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6694138','8','468245',TO_DATE('11/08/19','DD/MM/RR'),TO_DATE('17/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('17862825','8','821800',TO_DATE('18/08/19','DD/MM/RR'),TO_DATE('23/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18390208','3','826026',TO_DATE('22/08/19','DD/MM/RR'),TO_DATE('23/09/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18184240','7','303525',TO_DATE('02/09/19','DD/MM/RR'),TO_DATE('15/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18829466','7','787934',TO_DATE('05/09/19','DD/MM/RR'),TO_DATE('13/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('6275202','1','611059',TO_DATE('21/08/19','DD/MM/RR'),TO_DATE('03/10/19','DD/MM/RR'));
INSERT INTO asesoria VALUES ('18505021','4','393538',TO_DATE('26/08/19','DD/MM/RR'),TO_DATE('19/10/19','DD/MM/RR'));

COMMIT;


ALTER SESSION SET NLS_TERRITORY = 'CHILE';
ALTER SESSION SET NLS_LANGUAGE = 'SPANISH';


-- VARIABLES TIPO BIND PARA GUARDAR LOS DATOS CORRESPONDIENTE 
-- A LA FECHA DE DE LA QUE SE QUIERE OBTENER LA DATA
VAR b_mes_proceso VARCHAR2;
EXEC :b_mes_proceso := '06';

VAR b_anno_proceso VARCHAR2;
EXEC :b_anno_proceso := '2021';

VAR b_fecha_proceso VARCHAR2;
EXEC :b_fecha_proceso := :b_mes_proceso || :b_anno_proceso;

-- VARIABLES TIPO BIND PARA GUARDAR EL MONTO LIMITE DE LAS ASIGNACIONES
VAR b_limite_total_asignaciones NUMBER;
EXEC :b_limite_total_asignaciones := 250000;

DECLARE

    v_numero_asesorias NUMBER(3);
    v_total_honorarios NUMBER;
    v_comuna NUMBER;
    v_tipo_contrato NUMBER(1);
    
    --VARRAY QUE GUARDA LOS PORCENTAJES PARA EL CALCULO DEL MONTO EXTRA DE LA MOVILIZACION 
    TYPE VARRAY_PORC_MOV_EXTRA IS VARRAY(5) OF NUMBER;
    va_porc_mov_extra VARRAY_PORC_MOV_EXTRA := VARRAY_PORC_MOV_EXTRA(0.02, 0.04, 0.05, 0.07, 0.09);
    
    -- REGISTROS
    r_resumen_mes RESUMEN_MES_PROFESION%ROWTYPE;
    r_detalle_asignacion DETALLE_ASIGNACION_MES%ROWTYPE;
    
    -- VARIABLES PARA MANEJAR EXCEPCIONES
    e_excepcion_usuario EXCEPTION;
    v_sql_msj VARCHAR2(250);
    
    -- CURSOR QUE RECORRE LAS PROFESIONES
    CURSOR c_resumen IS
        SELECT
            cod_profesion
            ,nombre_profesion
        FROM 
            Profesion 
        ORDER BY
            nombre_profesion ASC;
            
    -- CURSOR PARAMETRIZADO, CON LA PROFESION, PARA OBTENER LOS DATOS BASICOS DEL
    --PROFESIONAL
    CURSOR c_detalle(vc_profesion NUMBER) IS
        SELECT 
            DISTINCT p.numrun_prof RUN_PROF
            ,p.cod_comuna
            ,p.cod_tpcontrato
            ,p.nombre
            ,p.appaterno
        FROM
          Profesional p
            INNER JOIN Asesoria a ON p.numrun_prof = a.numrun_prof
        WHERE
            p.cod_profesion = vc_profesion
            AND TO_CHAR(a.inicio_asesoria, 'MMYY') = :b_mes_proceso || SUBSTR(:b_anno_proceso, -2)
        ORDER BY 
            p.appaterno
            ,p.nombre;
           
    --CURSOR Y VARIABLES PARA CALCULAR DINAMICAMENTE EL PORCENTAJE QUE CORRESPONDE
    --A LA ASIGNACION POR TIPO DE CONTRATO
    CURSOR c_tipo_contrato IS
        SELECT
            cod_tpcontrato,
            incentivo
        FROM Tipo_Contrato;
        
    v_cod_contrato NUMBER(1);
    v_codigo_iteracion NUMBER(1);
    v_incentivo NUMBER(2);
    
    
    -- VARIABLES PARA EL CALCULO POR ASIGNACION POR PROFESION
    v_cod_porc_prof NUMBER;
    v_asig_porc_prof NUMBER;
    
    --VARIABLE PARA GUARDAR EL TOTAL DE TODAS LAS ASIGNACIONES 
    v_asignaciones_calculadas NUMBER;
    
    --VARIABLES ACUMULADORAS PARA LA TABLA RESUMEN
    v_acumulador_asesorias NUMBER;
    v_acumulador_total_honorarios NUMBER;
    v_acumulador_total_movil_extra NUMBER;
    v_acumulador_total_contrato NUMBER;
    v_acumulador_total_profesion NUMBER;
    v_acumulador_total_asignaciones NUMBER;
   
    
BEGIN
    /* ELIMINACION Y CREACION DE SECUENCIA EN LA TABLA ERRORES_PROCESO */
    EXECUTE IMMEDIATE 'DROP SEQUENCE sq_error';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE sq_error START WITH 1 INCREMENT BY 1';
      
    
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RESUMEN_MES_PROFESION';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DETALLE_ASIGNACION_MES';     
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ERRORES_PROCESO';
    
    /* APERTURA DE CURSORES */
    FOR r_resumen IN c_resumen LOOP
        
        /* RESETEO DE VARIABLES ACUMULADOREAS */
        -- Por cada iteración, que corresponde a una profesion, las variables acumuladoras
        -- vuelven a cero para que los valores obtenidos siempre 
        -- correspondan a la profesión que se está iterando.
        v_acumulador_asesorias := 0;
        v_acumulador_total_honorarios := 0;
        v_acumulador_total_movil_extra := 0;
        v_acumulador_total_contrato := 0;
        v_acumulador_total_profesion := 0;
        v_acumulador_total_asignaciones := 0;
        
        FOR r_detalle IN c_detalle(r_resumen.cod_profesion) LOOP
            /* ASIGNAR VALORES AL REGISTRO CORREPONDIENTE A LA TRABLA DE DETALLE */
            --Se asignan los valores que no requiere cálculos, al registro r_detalle_asignacion
            r_detalle_asignacion.mes_proceso := SUBSTR(:b_mes_proceso, 2, 1);
            r_detalle_asignacion.anno_proceso := :b_anno_proceso;
            r_detalle_asignacion.run_profesional := r_detalle.run_prof;
            r_detalle_asignacion.nombre_profesional := r_detalle.nombre || ' ' || r_detalle.appaterno;
            r_detalle_asignacion.profesion := r_resumen.nombre_profesion;
                  
            /* CALCULO ASESORIAS POR PROFESIONAL Y MONTO HONORARIO */
            -- Se calcula la cantidad de asesorias efectuadas por el profesional y
            -- además sumamos el total de honoraios correspondiente a las asesorias
            -- para la fecha indicada
            SELECT 
                COUNT(r_detalle_asignacion.run_profesional)
                ,NVL(SUM(honorario), 0)
            INTO
                 v_numero_asesorias, v_total_honorarios
            FROM
                Asesoria
            WHERE 
                numrun_prof = r_detalle_asignacion.run_profesional
               AND TO_CHAR(inicio_asesoria, 'MMYY') = :b_mes_proceso || SUBSTR(:b_anno_proceso, -2);
            
            
            r_detalle_asignacion.nro_asesorias := v_numero_asesorias;
            r_detalle_asignacion.monto_honorarios := v_total_honorarios;
            
            /* CALCULO ACUMULATIVO DEL TOTAL DE HONORARIOS POR PROFESION*/
             v_acumulador_total_honorarios :=  v_acumulador_total_honorarios + r_detalle_asignacion.monto_honorarios;
            
            
            /* CALCULO ASIGNACION MOVILIZACION POR COMUNA
            PROFE: El documento dice que para calcular el monto extra en la movilización, además de considerar la comuna para 
            hacer el cálculo, también hay que usar el total de los honorarios. 
            El documeto dice: "...2% de la suma de sus honorarios para aquellos profesionales que vivan en Santiago y que la suma de 
            sus honorarios es menor a $350.000". 
            Si se hace el cálculo con esa instrucción, el resultado no coincide con la tabla de ejemplo del documento, para eso no hay que considerar 
            el total de los honorarios
            */
            v_comuna := r_detalle.cod_comuna;
            r_detalle_asignacion.monto_movil_extra :=      
                CASE
                   WHEN v_comuna = 82 THEN r_detalle_asignacion.monto_honorarios * va_porc_mov_extra(1) -- Santiago
                   WHEN v_comuna = 83 THEN r_detalle_asignacion.monto_honorarios * va_porc_mov_extra(2) -- Nuñoa
                   WHEN v_comuna = 85 THEN r_detalle_asignacion.monto_honorarios * va_porc_mov_extra(3) -- La Reina
                   WHEN v_comuna = 86 THEN r_detalle_asignacion.monto_honorarios * va_porc_mov_extra(4) -- La Florida
                   WHEN v_comuna = 89 THEN r_detalle_asignacion.monto_honorarios * va_porc_mov_extra(5) -- Macul
                   ELSE 0
                END;
            
            /* CALCULO ACUMULATIVO DE ASIGNACION EXTRA PARA MOVILIZACION */
            v_acumulador_total_movil_extra := v_acumulador_total_movil_extra + r_detalle_asignacion.monto_movil_extra;
            
            
            /* CALCULO ASIGNACION POR TIPO DE CONTRATO */
            -- Por cada recorrido del cursor, este revisa y asigna el porcentaje dinámicamente
            -- dependiendo del tipo de contrato
            v_cod_contrato := r_detalle.cod_tpcontrato;
            FOR tipo_contrato IN c_tipo_contrato LOOP
                v_codigo_iteracion := tipo_contrato.cod_tpcontrato;
                v_incentivo := tipo_contrato.incentivo;
                
                IF v_cod_contrato = v_codigo_iteracion 
                    THEN
                       r_detalle_asignacion.monto_asig_tipocont := r_detalle_asignacion.monto_honorarios * (v_incentivo/100);
                   
                END IF;
            END LOOP;
            
            /* CALCULO ACUMULATIVO DE ASIGNACION EXTRA POR TIPO DE CONTRATO */
            v_acumulador_total_contrato := v_acumulador_total_contrato + r_detalle_asignacion.monto_asig_tipocont;
                
            /* CÁLCULO MONTO ASIGNACION POR PROFESION */
            -- Se crea un bloque anidado para poder crear un bloque exception particular para el bloque
            --y lanzar la excepción
            BEGIN
                SELECT
                    p.cod_profesion
                    ,ROUND(pp.asignacion, 1)
                    INTO v_cod_porc_prof, v_asig_porc_prof
                FROM 
                    Profesional p
                    INNER JOIN Porcentaje_Profesion pp ON p.cod_profesion = pp.cod_profesion
                WHERE
                    numrun_prof = r_detalle_asignacion.run_profesional
                    AND pp.cod_profesion = p.cod_profesion;
                    
                r_detalle_asignacion.monto_asig_profesion := r_detalle_asignacion.monto_honorarios * (v_asig_porc_prof / 100);
                
                
                
             /* DECLARACION DE EXCEPCION TIPO SQL */   
             -- Cuando la query realizada en el Select anterior no encuentre resultados 
             -- se lanzará la excepción, aplicamos la lógica de negocio requerida y guardamos
             -- la información relevante del error en la tabla Errores_Proceso.
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_sql_msj := SQLERRM;
                    
                    r_detalle_asignacion.monto_asig_profesion := 0;
                    
                    INSERT INTO Errores_Proceso VALUES(
                        SQ_ERROR.NEXTVAL
                        ,v_sql_msj
                        ,'Error al obtener porcentaje de asignacion para el run Nro. ' || 
                            LPAD( 
                                TO_CHAR( SUBSTR(r_detalle_asignacion.run_profesional, 1, LENGTH(r_detalle_asignacion.run_profesional) - 6) ), 2, '0' ) || '.' ||
                            TO_CHAR( SUBSTR(r_detalle_asignacion.run_profesional, LENGTH(r_detalle_asignacion.run_profesional) - 5, 3 ) ) || '.' ||
                            TO_CHAR( SUBSTR(r_detalle_asignacion.run_profesional, LENGTH(r_detalle_asignacion.run_profesional) - 2, 3 ) )
                    );
                    
                
            END;
            
            /* CALCULO ACUMULATIVO DE ASIGNACION EXTRAS POR PROFESIÓN */
            v_acumulador_total_profesion := v_acumulador_total_profesion + r_detalle_asignacion.monto_asig_profesion;
            
            /* CALCULO TOTAL ASIGNACIONES */
            BEGIN
                v_asignaciones_calculadas :=
                    r_detalle_asignacion.monto_movil_extra 
                    + r_detalle_asignacion.monto_asig_tipocont 
                    +  r_detalle_asignacion.monto_asig_profesion;
                    
                r_detalle_asignacion.monto_total_asignaciones := v_asignaciones_calculadas;
                
                
            /* DECLARACION DE EXCEPCION PERSONALIZADA */   
             -- Si las asignaciones calculadas superan el límite se lanza un error, para que este
             -- pueda ser capturado por la excepción y ser registrado en la tabla de errores
             -- Y también se aplicará la lógica de negocio requerida.
            IF v_asignaciones_calculadas > :b_limite_total_asignaciones  
                THEN RAISE e_excepcion_usuario;
            END IF;
                            
            EXCEPTION 
                WHEN e_excepcion_usuario THEN
                   INSERT INTO Errores_Proceso VALUES(
                        SQ_ERROR.NEXTVAL
                        ,'Error, profesional supera el monto límite de asignaciones. Run Nro. ' || 
                            LPAD( 
                                TO_CHAR( SUBSTR(r_detalle_asignacion.run_profesional, 1, LENGTH(r_detalle_asignacion.run_profesional) - 6) ), 2, '0' ) || '.' ||
                            TO_CHAR( SUBSTR(r_detalle_asignacion.run_profesional, LENGTH(r_detalle_asignacion.run_profesional) - 5, 3 ) ) || '.' ||
                            TO_CHAR( SUBSTR(r_detalle_asignacion.run_profesional, LENGTH(r_detalle_asignacion.run_profesional) - 2, 3 ) )
                        ,'Se reemplazó el monto total de las asignaciones calculadas de ' || v_asignaciones_calculadas || ' por el monto límite de ' || :b_limite_total_asignaciones 
                    ); 
                   
                   -- Cuando el monto total de asignaciones es mayor al límite declardo, este será el total de asignaciones.
                   r_detalle_asignacion.monto_total_asignaciones := :b_limite_total_asignaciones;
            END;
            
            /* CALCULO ACUMULATIVO DEL TOTAL DE LAS ASIGNACIONES */
            v_acumulador_total_asignaciones := v_acumulador_total_asignaciones + r_detalle_asignacion.monto_total_asignaciones;

            /* SE INSERTA EL REGISTRO EN LA TABLA DE DETALLE */
            INSERT INTO Detalle_Asignacion_Mes VALUES r_detalle_asignacion;
            
            /* CALCULO ACUMULATIVO DEL TOTAL DE ASESORIAS */
            v_acumulador_asesorias := r_detalle_asignacion.nro_asesorias + v_acumulador_asesorias;
            
        END LOOP;
        
        /* SE ASIGNA LOS DATOS CORRESPONDIENTES DENTRO DEL REGISTRO DESTINADO AL RESUMEN */
        r_resumen_mes.anno_mes_proceso := :b_anno_proceso || :b_mes_proceso;
        r_resumen_mes.profesion := r_resumen.nombre_profesion;
        r_resumen_mes.total_asesorias := v_acumulador_asesorias;
        r_resumen_mes.monto_total_honorarios := v_acumulador_total_honorarios;
        r_resumen_mes.monto_total_movil_extra := v_acumulador_total_movil_extra;
        r_resumen_mes.monto_total_asig_tipocont := v_acumulador_total_contrato;
        r_resumen_mes.monto_total_asig_prof := v_acumulador_total_profesion;
        r_resumen_mes.monto_total_asignaciones := v_acumulador_total_asignaciones;
        
        /* SE INSERTA EL REGISTRO EN LA TABLA DE RESUMEN */
        INSERT INTO Resumen_Mes_Profesion VALUES r_resumen_mes;
        
    END LOOP;
    COMMIT;
END;

/

SELECT * FROM Detalle_Asignacion_Mes;
SELECT * FROM Resumen_Mes_Profesion;
SELECT * FROM Errores_Proceso;


