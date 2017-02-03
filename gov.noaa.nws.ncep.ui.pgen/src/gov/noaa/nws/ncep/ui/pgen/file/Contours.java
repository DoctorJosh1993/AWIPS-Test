//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.10 in JDK 6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2010.10.27 at 12:23:04 PM EDT 
//


package gov.noaa.nws.ncep.ui.pgen.file;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


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
 *         &lt;element ref="{}DECollection" maxOccurs="unbounded" minOccurs="0"/>
 *       &lt;/sequence>
 *       &lt;attribute name="cint" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="time2" type="{http://www.w3.org/2001/XMLSchema}dateTime" />
 *       &lt;attribute name="time1" type="{http://www.w3.org/2001/XMLSchema}dateTime" />
 *       &lt;attribute name="forecastHour" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="level" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="parm" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="pgenType" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="pgenCategory" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="collectionName" type="{http://www.w3.org/2001/XMLSchema}string" />
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "deCollection"
})
@XmlRootElement(name = "Contours")
public class Contours {

    @XmlElement(name = "DECollection")
    protected List<DECollection> deCollection;
    @XmlAttribute
    protected String cint;
    @XmlAttribute
    @XmlSchemaType(name = "dateTime")
    protected XMLGregorianCalendar time2;
    @XmlAttribute
    @XmlSchemaType(name = "dateTime")
    protected XMLGregorianCalendar time1;
    @XmlAttribute
    protected String forecastHour;
    @XmlAttribute
    protected String level;
    @XmlAttribute
    protected String parm;
    @XmlAttribute
    protected String pgenType;
    @XmlAttribute
    protected String pgenCategory;
    @XmlAttribute
    protected String collectionName;

    /**
     * Gets the value of the deCollection property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the deCollection property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getDECollection().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link DECollection }
     * 
     * 
     */
    public List<DECollection> getDECollection() {
        if (deCollection == null) {
            deCollection = new ArrayList<DECollection>();
        }
        return this.deCollection;
    }

    /**
     * Gets the value of the cint property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCint() {
        return cint;
    }

    /**
     * Sets the value of the cint property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCint(String value) {
        this.cint = value;
    }

    /**
     * Gets the value of the time2 property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getTime2() {
        return time2;
    }

    /**
     * Sets the value of the time2 property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setTime2(XMLGregorianCalendar value) {
        this.time2 = value;
    }

    /**
     * Gets the value of the time1 property.
     * 
     * @return
     *     possible object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public XMLGregorianCalendar getTime1() {
        return time1;
    }

    /**
     * Sets the value of the time1 property.
     * 
     * @param value
     *     allowed object is
     *     {@link XMLGregorianCalendar }
     *     
     */
    public void setTime1(XMLGregorianCalendar value) {
        this.time1 = value;
    }

    /**
     * Gets the value of the forecastHour property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getForecastHour() {
        return forecastHour;
    }

    /**
     * Sets the value of the forecastHour property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setForecastHour(String value) {
        this.forecastHour = value;
    }

    /**
     * Gets the value of the level property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLevel() {
        return level;
    }

    /**
     * Sets the value of the level property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLevel(String value) {
        this.level = value;
    }

    /**
     * Gets the value of the parm property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getParm() {
        return parm;
    }

    /**
     * Sets the value of the parm property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setParm(String value) {
        this.parm = value;
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
     * Gets the value of the collectionName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCollectionName() {
        return collectionName;
    }

    /**
     * Sets the value of the collectionName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCollectionName(String value) {
        this.collectionName = value;
    }

}