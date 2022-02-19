CREATE SCHEMA Actividad1;

CREATE TABLE Actividad1.GIMNASIO_ACT1 (
    cif 		integer 			   UNIQUE NOT NULL, 
    direccion  	character varying(100) NOT NULL,
    cp  		character varying(10)  NOT NULL,
    tlf  		character varying(20)  NOT NULL,
    
    CONSTRAINT cp_gym PRIMARY KEY (cif) 
);

CREATE TABLE Actividad1.CLIENTE (
	id  		serial,
    nombre 		character varying(25)  NOT NULL, 
    apellido1  	character varying(20)  NOT NULL,
    apellido2  	character varying(20)  NOT NULL,
    direccion  	character varying(100) NOT NULL,
    cp  		character varying(10)  NOT NULL,
    tlf  		character varying(20)  NOT NULL,
    iban 		character varying(50)  NOT NULL,
    gimnasio 	integer 			   NOT NULL,
    
    CONSTRAINT cp_cliente PRIMARY KEY (id),
    CONSTRAINT caj_cli_gym   FOREIGN KEY (gimnasio)
                REFERENCES Actividad1.GIMNASIO_ACT1(cif)
                ON DELETE CASCADE
                ON UPDATE CASCADE
);

CREATE TABLE Actividad1.ABONO (
    id		 		serial, 
    nombre 			character varying(15) NOT NULL, 
    descripcion  	character varying(100) NOT NULL,
    coste  			numeric(6,2)          NOT NULL DEFAULT 10.0,
    
    CONSTRAINT cp_abono PRIMARY KEY (id) 
);

CREATE TABLE Actividad1.CURSO (
    id 						serial, 
    nombre 					character varying(15) NOT NULL, 
    descripcion 			character varying(50) NOT NULL,
	max_participantes 		int					  NOT NULL,
    coste  					numeric(6,2)          NOT NULL DEFAULT 0.0,
    
    CONSTRAINT cp_curso PRIMARY KEY (id)
);


CREATE DOMAIN Actividad1.rutina_valor AS character varying(25) 
          CHECK (VALUE IN ('Pérdida peso', 'Ganancia volumen', 'Tonificación', 'Mejora rendimiento', 'Musculación'));
		  
CREATE TABLE Actividad1.SUSCRIPCION (
	id 				serial,
    f_inicio 		date 					 NOT NULL,
    f_final 		date,
    pago 			boolean					 NOT NULL,
    rutina 			Actividad1.rutina_valor,
    cliente 		integer 				 NOT NULL,
    abono   		integer,
    curso 			integer,	
    
    CONSTRAINT cp_suscripcion PRIMARY KEY (id), 
    CONSTRAINT caj_cli_sus FOREIGN KEY (cliente)
				REFERENCES Actividad1.CLIENTE(id)
				ON DELETE RESTRICT
				ON UPDATE CASCADE, 
    CONSTRAINT caj_abn_sus FOREIGN KEY (abono)
				REFERENCES Actividad1.ABONO(id)
				ON DELETE RESTRICT
				ON UPDATE CASCADE,
    CONSTRAINT caj_curso_sus FOREIGN KEY (curso)
				REFERENCES Actividad1.CURSO(id)
				ON DELETE RESTRICT
				ON UPDATE CASCADE
);

CREATE TABLE Actividad1.ZONA (
    id			serial, 
    nombre 		character varying(25) NOT NULL, 
    descripcion character varying(75) NOT NULL,
    
    CONSTRAINT cp_zona PRIMARY KEY (id)
);

CREATE TABLE Actividad1.AUTORIZA (
	codigo_abono  integer NOT NULL,
	codigo_zona integer NOT NULL,
	CONSTRAINT cp_autoriza PRIMARY KEY (codigo_abono, codigo_zona), 
	CONSTRAINT caj_auto_abo FOREIGN KEY (codigo_abono)
				  REFERENCES Actividad1.ABONO(id)
				  ON DELETE CASCADE 
				  ON UPDATE CASCADE,  
	CONSTRAINT caj_auto_zona FOREIGN KEY (codigo_zona)
				  REFERENCES Actividad1.ZONA(id)
				  ON DELETE CASCADE 
				  ON UPDATE CASCADE  
);

CREATE DOMAIN Actividad1.maquina_estado AS character varying(15) 
          CHECK (VALUE IN ('Activa', 'En reparación', 'Averiada'));
		
CREATE TABLE Actividad1.MAQUINAS (
    id 			serial, 
    tipo 		character varying(15) 	  NOT NULL, 
    estado 		Actividad1.maquina_estado NOT NULL,
    zona 		integer 				  NOT NULL,
	
    CONSTRAINT cp_maquina PRIMARY KEY (id),
    CONSTRAINT caj_maq_zona FOREIGN KEY (zona)
				REFERENCES Actividad1.ZONA(id)
				ON DELETE RESTRICT
				ON UPDATE CASCADE	
);

CREATE TABLE Actividad1.TURNO (
    id 			serial, 
    entrada 	time   NOT NULL,
    salida 		time   NOT NULL,

    CONSTRAINT cp_turno PRIMARY KEY (id)
);

CREATE TABLE Actividad1.EMPLEADO (
    id			serial, 
    nombre 		character varying(25) NOT NULL, 
    apellido1  	character varying(20) NOT NULL,
    apellido2  	character varying(20) NOT NULL,
    direccion  	character varying(100) NOT NULL,
    cp  		character varying(10) NOT NULL,
    tlf  		character varying(20) NOT NULL,
    iban 		character varying(50) NOT NULL,	
    gym 		integer 			  NOT NULL,
    zona 		integer,
    turno 		integer 			  NOT NULL,
    
    CONSTRAINT cp_empleado PRIMARY KEY (id),
    CONSTRAINT caj_gym_emp FOREIGN KEY (gym)
				REFERENCES Actividad1.GIMNASIO_ACT1(cif)
				ON DELETE CASCADE
				ON UPDATE CASCADE, 
    CONSTRAINT caj_zona_emp FOREIGN KEY (zona)
				REFERENCES Actividad1.ZONA(id)
				ON DELETE CASCADE
				ON UPDATE CASCADE,
    CONSTRAINT caj_turno_emp FOREIGN KEY (turno)
				REFERENCES Actividad1.TURNO(id)
				ON DELETE RESTRICT
				ON UPDATE CASCADE
);

CREATE TABLE Actividad1.IMPARTE (
	codigo_empleado  integer NOT NULL,
	codigo_curso integer NOT NULL,
	CONSTRAINT cp_imparte PRIMARY KEY (codigo_empleado, codigo_curso), 
	CONSTRAINT caj_imp_empl FOREIGN KEY (codigo_empleado)
				  REFERENCES Actividad1.EMPLEADO(id)
				  ON DELETE CASCADE 
				  ON UPDATE CASCADE,  
	CONSTRAINT caj_imp_curso FOREIGN KEY (codigo_curso)
				  REFERENCES Actividad1.CURSO(id)
				  ON DELETE CASCADE 
				  ON UPDATE CASCADE  
);

CREATE DOMAIN Actividad1.categoria AS character varying(25) 
          CHECK (VALUE IN ('Administrativo', 'Monitor', 'Técnico Mantenimiento', 'Limpieza', 'Administracion'));

CREATE TABLE Actividad1.NOMINA (
    id   	   		   serial,
    empleado    	   integer 	 	NOT NULL,
    fecha 			   date,
    sueldo_base 	   numeric(6,2) NOT NULL,
    plus_mantenimiento numeric(5,2) DEFAULT 0.0,
    plus_curso  	   numeric(5,2) DEFAULT 0.0,
    categoria   	   Actividad1.categoria,     
    
    CONSTRAINT cp_nomina PRIMARY KEY (id), 
    CONSTRAINT caj_empl_nom FOREIGN KEY (empleado)
				REFERENCES Actividad1.EMPLEADO(id)
				ON DELETE CASCADE
				ON UPDATE CASCADE
);
