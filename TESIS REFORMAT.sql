-- ============ TESIS CARRERA_HUAMANJULCA  ==============

use prueba01;
SET FOREIGN_KEY_CHECKS=0;
-- TABLAS ELIMINADAS (Con datos poco importantes)

DROP TABLE activo;
DROP TABLE almacen;
DROP TABLE bitacorausuario;
DROP TABLE clasificador;
DROP TABLE detraccion;
DROP TABLE tipocambio;
DROP TABLE ubigeo;
DROP TABLE ubigeo_inei;
DROP TABLE usuario;
DROP TABLE vendedor;

-- NO SE USAN
DROP TABLE categoriareclamo;
DROP TABLE conceptofijo;
DROP TABLE guiaremision;
DROP TABLE guiaremisiondetalle;
DROP TABLE informe;
DROP TABLE informe_archivos;
DROP TABLE informe_contacto;
DROP TABLE informe_plantilla;
DROP TABLE motivotraslado;
DROP TABLE movimiento;
DROP TABLE movimientodetalle;
DROP TABLE movimientodetalleconsumo;
DROP TABLE movimientopago;
DROP TABLE notacredito;
DROP TABLE notacreditodetalle;
DROP TABLE notacreditodetalleconsumo;
DROP TABLE pago;
DROP TABLE parametros;
DROP TABLE precioventa;
DROP TABLE productolote;
DROP TABLE productoplantilla;
DROP TABLE tipotransporte;


/* ====================================================== 

______ REECEPCION DE MUESTRA ______

	TABLAS RELACIONADAS
-	origendestino (cliente/proveedor, "nRMOrigenDestino_Id")
- 	origendestino (Tipo, "nRMODTipo") -> 1=proveedor, 2=cliente
- 	origendestinoarea (Area, "nRMArea_Id")
-   ordenservicio (Promover, "nRMOrdenServicio_Id")
*/

UPDATE recepcionmuestra
SET nRMArea_Id = 18
where nRMArea_Id IS NULL;

/*	RELACIONES	*/ 
ALTER TABLE recepcionmuestra
ADD CONSTRAINT fk_origen_destino_recepcion
FOREIGN KEY (nRMOrigenDestino_Id)
REFERENCES origendestino(OrigenDestino_Id);

ALTER TABLE recepcionmuestra
ADD CONSTRAINT fk_origen_destino_area_muestra
FOREIGN KEY (nRMArea_Id)
REFERENCES origendestinoarea(origendestinoarea_id);

ALTER TABLE recepcionmuestra
ADD CONSTRAINT fk_orden_servicio_recepcion
FOREIGN KEY (nRMOrdenServicio_Id)
REFERENCES ordenservicio(OrdenServicio_Id);

-- LIMPIAR
ALTER TABLE recepcionmuestra
DROP COLUMN nRMEliminado;

ALTER TABLE recepcionmuestra
DROP COLUMN nRMEstado;

ALTER TABLE recepcionmuestra
DROP COLUMN Usuario_Id;

ALTER TABLE recepcionmuestra
DROP COLUMN dRMFecha_Act;

--  ====================================================

/* ====================================================== 

______ REECEPCION MUESTRA DETALLE ______

	TABLAS RELACIONADAS
-	recepcionmuestra ("nRMDRecepcionMuestra_Id")
- 	prodserv ("nRMDProdServ_Id")
- 	metodo ("RMDMetodo")
-   moneda ("nRMDMoneda_Id)
- 	unidadmedida("sRMDUnidadMedida_Id")
*/

/*	RELACIONES	*/ 
ALTER TABLE recepcionmuestradetalle
ADD CONSTRAINT fk_recepcion_muestra
FOREIGN KEY (nRMDRecepcionMuestra_Id)
REFERENCES recepcionmuestra(RecepcionMuestra_Id);

ALTER TABLE recepcionmuestradetalle
ADD CONSTRAINT fk_prod_serv_recepcion
FOREIGN KEY (nRMDProdServ_Id)
REFERENCES prodserv(ProdServ_Id);

ALTER TABLE recepcionmuestradetalle
ADD CONSTRAINT fk_metodo_recepcion
FOREIGN KEY (nRMDMetodo)
REFERENCES metodo(Metodo_Id);

ALTER TABLE recepcionmuestradetalle MODIFY nRMDMoneda_Id INT(11);

ALTER TABLE recepcionmuestradetalle
ADD CONSTRAINT fk_moneda_recepcion_muestra
FOREIGN KEY (nRMDMoneda_Id)
REFERENCES moneda(Moneda_Id);

ALTER TABLE recepcionmuestradetalle
ADD CONSTRAINT fk_unidad_medida_recepcion
FOREIGN KEY (sRMDUnidadMedida_Id)
REFERENCES unidadmedida(UnidadMedida_Id);

-- LIMPIAR
ALTER TABLE recepcionmuestradetalle
DROP COLUMN nRMDEliminado;
--  ==============================================

/* ====================================================== 

___ ORDEN DE SERIVICIO ___

    TABLAS RELACIONADAS
- recepcionmuestra("nOSRecepcionMuestra_Id")
*/

/*	RELACIONES	*/ 
ALTER TABLE ordenservicio
ADD CONSTRAINT fk_recepcion_muestra_orden
FOREIGN KEY (nOSRecepcionMuestra_Id)
REFERENCES recepcionmuestra(RecepcionMuestra_Id);

-- LIMPIAR
ALTER TABLE ordenservicio
DROP COLUMN nOSEstado;

ALTER TABLE ordenservicio
DROP COLUMN nOSEliminado;

ALTER TABLE ordenservicio
DROP COLUMN Usuario_Id;

ALTER TABLE ordenservicio
DROP COLUMN dOSFecha_Act;
--  ====================================================

/* ====================================================== 

___ ORDEN DE SERIVICIO DETALLE ___

    TABLAS RELACIONADAS
- ordenservicio("nOSDOrdenServicio_Id
- prodserv("nOSDProdServ_Id")
*/

/*	RELACIONES	*/ 
ALTER TABLE ordenserviciodetalle
ADD CONSTRAINT fk_orden_servicio
FOREIGN KEY (nOSDOrdenServicio_Id)
REFERENCES ordenservicio(OrdenServicio_Id);

ALTER TABLE ordenserviciodetalle
ADD CONSTRAINT fk_prod_serv_orden
FOREIGN KEY (nOSDProdServ_Id)
REFERENCES prodserv(ProdServ_Id);

-- LIMPIAR
ALTER TABLE ordenserviciodetalle
DROP COLUMN nOSDEliminado;

--  ====================================================

/* ====================================================== 

______ COTIZACION ______

	TABLAS RELACIONADAS
-	origendestino (cliente/proveedor, "nMovOrigenDestino_Id")
-	origendestino (Tipo, "nRMODTipo") -> 1=proveedor, 2=cliente
-	documento ("Documento_ID)
-	moneda ("Moneda_Id")
*/

/*	RELACIONES	*/ 
ALTER TABLE cotizacion
ADD CONSTRAINT fk_origen_destino_cotizacion
FOREIGN KEY (nMovOrigenDestino_Id)
REFERENCES origendestino(OrigenDestino_Id);

ALTER TABLE cotizacion
ADD CONSTRAINT fk_documento
FOREIGN KEY (Documento_Id)
REFERENCES documento(Documento_ID);

ALTER TABLE cotizacion
ADD CONSTRAINT fk_moneda_cotizacion
FOREIGN KEY (Moneda_Id)
REFERENCES moneda(Moneda_Id);

-- LIMPIAR
ALTER TABLE cotizacion
DROP COLUMN sMovDocReferencia;

ALTER TABLE cotizacion
DROP COLUMN dMovPercepcion;

ALTER TABLE cotizacion
DROP COLUMN dMovRetencion;

ALTER TABLE cotizacion
DROP COLUMN nMovEstadoSunat;

ALTER TABLE cotizacion
DROP COLUMN nMovEstado;

ALTER TABLE cotizacion
DROP COLUMN nMovEliminado;

ALTER TABLE cotizacion
DROP COLUMN dMovFecha_Act;

ALTER TABLE cotizacion
DROP COLUMN Usuario_Id;

ALTER TABLE cotizacion
DROP COLUMN nMovClasificador_Id;

ALTER TABLE cotizacion
DROP COLUMN nMovMovimiento_Id;

ALTER TABLE cotizacion
DROP COLUMN nMovOrdenCampo_Id;

ALTER TABLE cotizacion
DROP COLUMN nMovVendedor_Id;

ALTER TABLE cotizacion
DROP COLUMN dMovICBPER;

ALTER TABLE cotizacion
DROP COLUMN dMovFechaVigencia;

ALTER TABLE cotizacion
DROP COLUMN sMovPhoneAtencion;

--  ====================================================

/* ====================================================== 

______ COTIZACION DETALLE ______

	TABLAS RELACIONADAS
-	cotizacion
-	prodserv
-	unidadmedida
-	metodo
*/

/*	RELACIONES	*/ 
ALTER TABLE cotizaciondetalle
ADD CONSTRAINT fk_movimiento /* COTIZACION */
FOREIGN KEY (Movimiento_Id)
REFERENCES cotizacion(Movimiento_Id);

ALTER TABLE cotizaciondetalle
ADD CONSTRAINT fk_prod_serv_cotizacion
FOREIGN KEY (Producto_Id)
REFERENCES prodserv(ProdServ_Id);

ALTER TABLE cotizaciondetalle
ADD CONSTRAINT fk_unidad_medida_cotizacion
FOREIGN KEY (nMovDetConUnidad_Id)
REFERENCES unidadmedida(UnidadMedida_Id);

ALTER TABLE cotizaciondetalle
ADD CONSTRAINT fk_metodo_cotizacion
FOREIGN KEY (nMovDetMetodo)
REFERENCES metodo(Metodo_Id);

--  ====================================================

/* ============================================

______ ORIGEN DESTINO AREA ______

	TABLAS RELACIONADAS
-	origendestino (Cliente/Proveedor)
*/

/*	RELACIONES	*/ 

ALTER TABLE origendestinoarea
ADD CONSTRAINT fk_origen_destino_area
FOREIGN KEY (OrigenDestino_Id)
REFERENCES origendestino(OrigenDestino_Id);

-- LIMPIAR
ALTER TABLE origendestinoarea
DROP COLUMN nODAreaEliminado;

ALTER TABLE origendestinoarea
DROP COLUMN dODAreaFecha_Act;

ALTER TABLE origendestinoarea
DROP COLUMN nODAreaEstado;

ALTER TABLE origendestinoarea
DROP COLUMN nODAreaUsuario_Id;

--  ====================================================

/* ============================================

______ DOCUMENTO ______

	TABLAS RELACIONADAS
-	tipomovimiento(nDocTipoMovimiento_Id)

*/

/*	RELACIONES	*/ 
ALTER TABLE documento
ADD CONSTRAINT fk_documento_tipo_movimiento
FOREIGN KEY (nDocTipoMovimiento_Id)
REFERENCES tipomovimiento(TipoMovimiento_Id);

-- LIMPIAR
ALTER TABLE documento
DROP COLUMN Almacen_Id;

ALTER TABLE documento
DROP COLUMN nDocNomAutomatico;

ALTER TABLE documento
DROP COLUMN sDocSiguiente;

ALTER TABLE documento
DROP COLUMN isFE;

ALTER TABLE documento
DROP COLUMN nDocEstado;

ALTER TABLE documento
DROP COLUMN nDocEliminado;

ALTER TABLE documento
DROP COLUMN dDocFecha_Act;

ALTER TABLE documento
DROP COLUMN Usuario_Id;

ALTER TABLE documento
DROP COLUMN nDocTipoImprimir;


--  ====================================================

/* ============================================

______ ORIGEN DESTINO ______

	TABLAS RELACIONADAS
-	

*/

-- LIMPIAR
ALTER TABLE origendestino
DROP COLUMN nODEstado;

ALTER TABLE origendestino
DROP COLUMN nProcliDepId;

ALTER TABLE origendestino
DROP COLUMN nProcliProvId;

ALTER TABLE origendestino
DROP COLUMN nProcliDistId;

ALTER TABLE origendestino
DROP COLUMN dODFechaActualizacion;

ALTER TABLE origendestino
DROP COLUMN nODUsuario_Id;

ALTER TABLE origendestino
DROP COLUMN nODEliminado;

ALTER TABLE origendestino
DROP COLUMN sODDireccionGR;

--  ====================================================

/* ============================================

______ UNIDAD MEDIDA ______

	TABLAS RELACIONADAS
-	

*/

-- LIMPIAR
ALTER TABLE unidadmedida
DROP COLUMN nUndPadre_Id;

ALTER TABLE unidadmedida
DROP COLUMN nUndFac_Cnv;

ALTER TABLE unidadmedida
DROP COLUMN sUndCodeSunat;

ALTER TABLE unidadmedida
DROP COLUMN nUndEstado;

ALTER TABLE unidadmedida
DROP COLUMN nUndEliminado;

ALTER TABLE unidadmedida
DROP COLUMN dUndFecha_Act;

ALTER TABLE unidadmedida
DROP COLUMN Usuario_Id;

--  ====================================================

/* ============================================

______ ORIGEN DESTINO CONTACTO ______

	TABLAS RELACIONADAS
-	origendestino(OrigenDestino_Id)

*/

/*	RELACIONES	*/ 
ALTER TABLE origendestinocontacto
ADD CONSTRAINT fk_origen_destino_contacto
FOREIGN KEY (OrigenDestino_Id)
REFERENCES origendestino(OrigenDestino_Id);

--  ====================================================

/* ============================================

______ METODO ______

	TABLAS RELACIONADAS
-

*/

-- LIMPIAR 
ALTER TABLE metodo
DROP COLUMN nMetUsuario_Id;

ALTER TABLE metodo
DROP COLUMN nMetEstado;

ALTER TABLE metodo
DROP COLUMN dMetFecha_Act;

ALTER TABLE metodo
DROP COLUMN nMetEliminado;

--  ====================================================

/* ============================================

______ PROD SERV ______

	TABLAS RELACIONADAS
-

*/

-- LIMPIAR 
ALTER TABLE prodserv
DROP COLUMN nProSrvEstado;

ALTER TABLE prodserv
DROP COLUMN nProSrvEliminado;

ALTER TABLE prodserv
DROP COLUMN dProSrvFecha_Act;

ALTER TABLE prodserv
DROP COLUMN Usuario_Id;

ALTER TABLE prodserv
DROP COLUMN ProSrvNomImagen;

ALTER TABLE prodserv
DROP COLUMN ProSrvNomImagen2;

ALTER TABLE prodserv
DROP COLUMN ProSrvNomImagen3;

ALTER TABLE prodserv
DROP COLUMN ProSrvNomImagen4;

--  ====================================================

/* ============================================

______ FAMILIA ______

	TABLAS RELACIONADAS
- prodserv(nProSrvFamilia_Id)

*/

/*	RELACIONES	*/ 
ALTER TABLE prodserv
ADD CONSTRAINT fk_prodserv_familia
FOREIGN KEY (nProSrvFamilia_Id)
REFERENCES familia(Familia_Id);

-- LIMPIAR 
ALTER TABLE familia
DROP COLUMN nFamEstado;

ALTER TABLE familia
DROP COLUMN nFamEliminado;

ALTER TABLE familia
DROP COLUMN dFamFecha_Act;

ALTER TABLE familia
DROP COLUMN Usuario_Id;



--  ====================================================


SET FOREIGN_KEY_CHECKS=1;


