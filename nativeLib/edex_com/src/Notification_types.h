/**
 * Autogenerated by Thrift Compiler (0.9.0)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */

/*****************************************************************************************
 * COPYRIGHT (c), 2009, RAYTHEON COMPANY
 * ALL RIGHTS RESERVED, An Unpublished Work
 *
 * RAYTHEON PROPRIETARY
 * If the end user is not the U.S. Government or any agency thereof, use
 * or disclosure of data contained in this source code file is subject to
 * the proprietary restrictions set forth in the Master Rights File.
 *
 * U.S. GOVERNMENT PURPOSE RIGHTS NOTICE
 * If the end user is the U.S. Government or any agency thereof, this source
 * code is provided to the U.S. Government with Government Purpose Rights.
 * Use or disclosure of data contained in this source code file is subject to
 * the "Government Purpose Rights" restriction in the Master Rights File.
 *
 * U.S. EXPORT CONTROLLED TECHNICAL DATA
 * Use or disclosure of data contained in this source code file is subject to
 * the export restrictions set forth in the Master Rights File.
 ******************************************************************************************/

/*
 * Extended thrift protocol to handle messages from edex.
 *
 * <pre>
 *
 * SOFTWARE HISTORY
 *
 * Date         Ticket#     Engineer    Description
 * ------------ ----------  ----------- --------------------------
 * 07/29/13       2215       bkowal     Regenerated for thrift 0.9.0
 *
 * </pre>
 *
 * @author bkowal
 * @version 1
 */
#ifndef Notification_TYPES_H
#define Notification_TYPES_H

#include <thrift/Thrift.h>
#include <thrift/TApplicationException.h>
#include <thrift/protocol/TProtocol.h>
#include <thrift/transport/TTransport.h>





typedef struct _com_raytheon_uf_common_dataplugin_message_DataURINotificationMessage__isset {
  _com_raytheon_uf_common_dataplugin_message_DataURINotificationMessage__isset() : dataURIs(false) {}
  bool dataURIs;
} _com_raytheon_uf_common_dataplugin_message_DataURINotificationMessage__isset;

class com_raytheon_uf_common_dataplugin_message_DataURINotificationMessage {
 public:

  static const char* ascii_fingerprint; // = "ACE4F644F0FDD289DDC4EE5B83BC13C0";
  static const uint8_t binary_fingerprint[16]; // = {0xAC,0xE4,0xF6,0x44,0xF0,0xFD,0xD2,0x89,0xDD,0xC4,0xEE,0x5B,0x83,0xBC,0x13,0xC0};

  com_raytheon_uf_common_dataplugin_message_DataURINotificationMessage() {
  }

  virtual ~com_raytheon_uf_common_dataplugin_message_DataURINotificationMessage() throw() {}

  std::vector<std::string>  dataURIs;

  _com_raytheon_uf_common_dataplugin_message_DataURINotificationMessage__isset __isset;

  void __set_dataURIs(const std::vector<std::string> & val) {
    dataURIs = val;
  }

  bool operator == (const com_raytheon_uf_common_dataplugin_message_DataURINotificationMessage & rhs) const
  {
    if (!(dataURIs == rhs.dataURIs))
      return false;
    return true;
  }
  bool operator != (const com_raytheon_uf_common_dataplugin_message_DataURINotificationMessage &rhs) const {
    return !(*this == rhs);
  }

  bool operator < (const com_raytheon_uf_common_dataplugin_message_DataURINotificationMessage & ) const;

  uint32_t read(::apache::thrift::protocol::TProtocol* iprot);
  uint32_t write(::apache::thrift::protocol::TProtocol* oprot) const;

};

void swap(com_raytheon_uf_common_dataplugin_message_DataURINotificationMessage &a, com_raytheon_uf_common_dataplugin_message_DataURINotificationMessage &b);



#endif
