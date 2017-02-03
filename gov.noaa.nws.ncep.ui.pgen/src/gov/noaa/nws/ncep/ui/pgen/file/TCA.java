//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.3 in JDK 1.6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2009.10.05 at 02:15:43 PM EDT 
//


package gov.noaa.nws.ncep.ui.pgen.file;

import gov.noaa.nws.ncep.ui.pgen.tca.TropicalCycloneAdvisory;

import java.util.ArrayList;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import javax.xml.datatype.XMLGregorianCalendar;

import com.raytheon.uf.common.serialization.adapters.CoordAdapter;
import com.vividsolutions.jts.geom.Coordinate;


/**
 * <p>Java class for anonymous complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *       &lt;/sequence>
 *       &lt;attribute name="stormNumber" type="{http://www.w3.org/2001/XMLSchema}int" />
 *       &lt;attribute name="stormName" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="basin" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="issueStatus" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="stormType" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="advisoryNumber" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="advisoryTime" type="{http://www.w3.org/2001/XMLSchema}dateTime" />
 *       &lt;attribute name="timeZone" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="pgenType" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="pgenCategory" type="{http://www.w3.org/2001/XMLSchema}string" />
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "")
@XmlRootElement(name = "TCA")
public class TCA {

    @XmlAttribute
    protected Integer stormNumber;
    @XmlAttribute
    protected String stormName;
    @XmlAttribute
    protected String basin;
    @XmlAttribute
    protected String issueStatus;
    @XmlAttribute
    protected String stormType;
    @XmlAttribute
    protected String advisoryNumber;
    @XmlAttribute
    protected XMLGregorianCalendar advisoryTime;
    @XmlAttribute
    protected String timeZone;
    
    @XmlJavaTypeAdapter(value = CoordAdapter.class)
    @XmlAttribute
    protected Coordinate textLocation;
    
    @XmlAttribute
    protected String pgenType;
    @XmlAttribute
    protected String pgenCategory;
    
    @XmlElement(name="advisory")
    protected ArrayList<TropicalCycloneAdvisory> advisories;

    /**
     * Gets the value of the stormNumber property.
     * 
     * @return
     *     possible object is
     *     {@link Integer }
     *     
     */
    public Integer getStormNumber() {
        return stormNumber;
    }

    /**
     * Sets the value of the stormNumber property.
     * 
     * @param value
     *     allowed object is
     *     {@link Integer }
     *     
     */
    public void setStormNumber(Integer value) {
        this.stormNumber = value;
    }

    /**
     * Gets the value of the stormName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStormName() {
        return stormName;
    }

    /**
     * Sets the value of the stormName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStormName(String value) {
        this.stormName = value;
    }

    /**
     * Gets the value of the basin property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getBasin() {
        return basin;
    }

    /**
     * Sets the value of the basin property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setBasin(String value) {
        this.basin = value;
    }

    /**
     * Gets the value of the issueStatus property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIssueStatus() {
        return issueStatus;
    }

    /**
     * Sets the value of the issueStatus property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIssueStatus(String value) {
        this.issueStatus = value;
    }

    /**
     * Gets the value of the stormType property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getStormType() {
        return stormType;
    }

    /**
     * Sets the value of the stormType property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setStormType(String value) {
        this.stormType = value;
    }

    /**
     * Gets the value of the advisoryNumber property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAdvisoryNumber() {
        return advisoryNumber;
    }

    /**
     * Sets the value of the advisoryNumber property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAdvisoryNumber(String value) {
        this.advisoryNumber = value;
    }

    /**
     * Gets the value of the advisoryTime property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getAdvisoryTime() {
        return advisoryTime;
    }

    /**
     * Sets the value of the advisoryTime property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setAdvisoryTime(XMLGregorianCalendar value) {
        this.advisoryTime = value;
    }

    /**
     * Gets the value of the timeZone property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTimeZone() {
        return timeZone;
    }

    /**
     * Sets the value of the timeZone property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTimeZone(String value) {
        this.timeZone = value;
    }

    /**
     * Gets the value of the pgenType property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPgenType() {
        return pgenType;
    }

    /**
     * Sets the value of the pgenType property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPgenType(String value) {
        this.pgenType = value;
    }

    /**
     * Gets the value of the pgenCategory property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getPgenCategory() {
        return pgenCategory;
    }

    /**
     * Sets the value of the pgenCategory property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setPgenCategory(String value) {
        this.pgenCategory = value;
    }

	/**
	 * @return the textLocation
	 */
	public Coordinate getTextLocation() {
		return textLocation;
	}

	/**
	 * @param textLocation the textLocation to set
	 */
	public void setTextLocation(Coordinate textLocation) {
		this.textLocation = textLocation;
	}

	/**
	 * @return the advisories
	 */
	public ArrayList<TropicalCycloneAdvisory> getAdvisories() {
		return advisories;
	}

	/**
	 * @param advisories the advisories to set
	 */
	public void setAdvisories(ArrayList<TropicalCycloneAdvisory> advisories) {
		this.advisories = advisories;
	}

}