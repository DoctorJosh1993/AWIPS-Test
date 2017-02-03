/**
* This software was developed and / or modified by Raytheon Company,
* pursuant to Contract DG133W-05-CQ-1067 with the US Government.
* 
* U.S. EXPORT CONTROLLED TECHNICAL DATA
* This software product contains export-restricted data whose
* export/transfer/disclosure is restricted by U.S. law. Dissemination
* to non-U.S. persons whether in the United States or abroad requires
* an export license or other authorization.
* 
* Contractor Name:        Raytheon Company
* Contractor Address:     6825 Pine Street, Suite 340
*                         Mail Stop B8
*                         Omaha, NE 68106
*                         402.291.0100
* 
* See the AWIPS II Master Rights File ("Master Rights File.pdf") for
* further licensing information.
**/
package com.raytheon.uf.common.dataplugin.shef.tables;
// default package
// Generated Oct 17, 2008 2:22:17 PM by Hibernate Tools 3.2.2.GA

import java.util.Date;
import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * Rwresult generated by hbm2java
 * 
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * Oct 17, 2008                        Initial generation by hbm2java
 * Aug 19, 2011      10672     jkorman Move refactor to new project
 * Oct 07, 2013       2361     njensen Removed XML annotations
 * 
 * </pre>
 * 
 * @author jkorman
 * @version 1.1
 */
@Entity
@Table(name = "rwresult")
@com.raytheon.uf.common.serialization.annotations.DynamicSerialize
public class Rwresult extends com.raytheon.uf.common.dataplugin.persist.PersistableDataObject implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private RwresultId id;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Short numGagAvail;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Integer numRadAvail;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Integer numPseudoGages;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String satAvail;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String mapxFieldType;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String drawPrecip;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String autoSave;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Date lastExecTime;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Date lastSaveTime;

    public Rwresult() {
    }

    public Rwresult(RwresultId id) {
        this.id = id;
    }

    public Rwresult(RwresultId id, Short numGagAvail, Integer numRadAvail,
            Integer numPseudoGages, String satAvail, String mapxFieldType,
            String drawPrecip, String autoSave, Date lastExecTime,
            Date lastSaveTime) {
        this.id = id;
        this.numGagAvail = numGagAvail;
        this.numRadAvail = numRadAvail;
        this.numPseudoGages = numPseudoGages;
        this.satAvail = satAvail;
        this.mapxFieldType = mapxFieldType;
        this.drawPrecip = drawPrecip;
        this.autoSave = autoSave;
        this.lastExecTime = lastExecTime;
        this.lastSaveTime = lastSaveTime;
    }

    @EmbeddedId
    @AttributeOverrides( {
            @AttributeOverride(name = "rfc", column = @Column(name = "rfc", nullable = false, length = 8)),
            @AttributeOverride(name = "obstime", column = @Column(name = "obstime", nullable = false, length = 29)) })
    public RwresultId getId() {
        return this.id;
    }

    public void setId(RwresultId id) {
        this.id = id;
    }

    @Column(name = "num_gag_avail")
    public Short getNumGagAvail() {
        return this.numGagAvail;
    }

    public void setNumGagAvail(Short numGagAvail) {
        this.numGagAvail = numGagAvail;
    }

    @Column(name = "num_rad_avail")
    public Integer getNumRadAvail() {
        return this.numRadAvail;
    }

    public void setNumRadAvail(Integer numRadAvail) {
        this.numRadAvail = numRadAvail;
    }

    @Column(name = "num_pseudo_gages")
    public Integer getNumPseudoGages() {
        return this.numPseudoGages;
    }

    public void setNumPseudoGages(Integer numPseudoGages) {
        this.numPseudoGages = numPseudoGages;
    }

    @Column(name = "sat_avail", length = 1)
    public String getSatAvail() {
        return this.satAvail;
    }

    public void setSatAvail(String satAvail) {
        this.satAvail = satAvail;
    }

    @Column(name = "mapx_field_type", length = 10)
    public String getMapxFieldType() {
        return this.mapxFieldType;
    }

    public void setMapxFieldType(String mapxFieldType) {
        this.mapxFieldType = mapxFieldType;
    }

    @Column(name = "draw_precip", length = 1)
    public String getDrawPrecip() {
        return this.drawPrecip;
    }

    public void setDrawPrecip(String drawPrecip) {
        this.drawPrecip = drawPrecip;
    }

    @Column(name = "auto_save", length = 1)
    public String getAutoSave() {
        return this.autoSave;
    }

    public void setAutoSave(String autoSave) {
        this.autoSave = autoSave;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "last_exec_time", length = 29)
    public Date getLastExecTime() {
        return this.lastExecTime;
    }

    public void setLastExecTime(Date lastExecTime) {
        this.lastExecTime = lastExecTime;
    }

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "last_save_time", length = 29)
    public Date getLastSaveTime() {
        return this.lastSaveTime;
    }

    public void setLastSaveTime(Date lastSaveTime) {
        this.lastSaveTime = lastSaveTime;
    }

}