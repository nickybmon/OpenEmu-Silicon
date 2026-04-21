/* Unity build file — compiles all rcheevos source as a single translation unit.
 * This is the file added to the OpenEmuHelperApp Xcode target.
 * Compile with -DRC_NO_THREADS=1.
 */

/* Top-level */
#include "src/rc_client.c"
#include "src/rc_compat.c"
#include "src/rc_util.c"
#include "src/rc_version.c"

/* Core achievement evaluation engine */
#include "src/rcheevos/alloc.c"
#include "src/rcheevos/condition.c"
#include "src/rcheevos/condset.c"
#include "src/rcheevos/consoleinfo.c"
#include "src/rcheevos/format.c"
#include "src/rcheevos/lboard.c"
#include "src/rcheevos/memref.c"
#include "src/rcheevos/operand.c"
#include "src/rcheevos/rc_validate.c"
#include "src/rcheevos/richpresence.c"
#include "src/rcheevos/runtime.c"
#include "src/rcheevos/runtime_progress.c"
#include "src/rcheevos/trigger.c"
#include "src/rcheevos/value.c"

/* REST API request builders */
#include "src/rapi/rc_api_common.c"
#include "src/rapi/rc_api_editor.c"
#include "src/rapi/rc_api_info.c"
#include "src/rapi/rc_api_runtime.c"
#include "src/rapi/rc_api_user.c"

/* ROM hashing */
#include "src/rhash/aes.c"
#include "src/rhash/cdreader.c"
#include "src/rhash/hash.c"
#include "src/rhash/hash_disc.c"
#include "src/rhash/hash_encrypted.c"
#include "src/rhash/hash_rom.c"
#include "src/rhash/hash_zip.c"
#include "src/rhash/md5.c"
