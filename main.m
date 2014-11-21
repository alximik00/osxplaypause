#import <IOKit/hidsystem/IOHIDLib.h>
#import <IOKit/hidsystem/ev_keymap.h>
#import <strings.h>
#include <stdio.h>

enum {
  COMMAND_PLAY = 1,
  COMMAND_NEXT = 2,
  COMMAND_PREV = 3
};

int main(int argc, char *argv[]) {
  int keyCode = 0;

  if (argc > 1) {
    if (strcmp("next", argv[1])==0) {
      keyCode = NX_KEYTYPE_NEXT;
    } else if (strcmp("prev", argv[1])==0) {
      keyCode = NX_KEYTYPE_PREVIOUS; 
    } else if (strcmp("play", argv[1])==0) {
      keyCode = NX_KEYTYPE_PLAY;
    }
  }

  if (keyCode == 0) {
    return 0;
  }

  mach_port_t connect = 0;
  mach_port_t master_port;
  mach_port_t service;
  mach_port_t iter;

  IOMasterPort(MACH_PORT_NULL, &master_port);
  IOServiceGetMatchingServices(master_port, IOServiceMatching(kIOHIDSystemClass), &iter);

  service = IOIteratorNext(iter);
  IOObjectRelease(iter);

  IOServiceOpen(service, mach_task_self(), kIOHIDParamConnectType, &connect);
  IOObjectRelease(service);

  IOGPoint location = {0, 0};
  NXEventData eventData;

  bzero(&eventData, sizeof(NXEventData));
  eventData.compound.subType = NX_SUBTYPE_AUX_CONTROL_BUTTONS;
  eventData.compound.misc.L[0] = keyCode << 16 | NX_KEYDOWN << 8;
  IOHIDPostEvent(connect, NX_SYSDEFINED, location, &eventData, kNXEventDataVersion, 0xA, FALSE);

  bzero(&eventData, sizeof(NXEventData));
  eventData.compound.subType = NX_SUBTYPE_AUX_CONTROL_BUTTONS;
  eventData.compound.misc.L[0] = keyCode << 16 | NX_KEYUP << 8;
  IOHIDPostEvent(connect, NX_SYSDEFINED, location, &eventData, kNXEventDataVersion, 0xB, FALSE);

  return 0;
}
