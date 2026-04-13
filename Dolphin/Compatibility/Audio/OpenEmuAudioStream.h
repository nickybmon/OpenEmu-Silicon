// Copyright (c) 2018, OpenEmu Team
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the OpenEmu Team nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY OpenEmu Team ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL OpenEmu Team BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

// Copyright 2008 Dolphin Emulator Project
// Licensed under GPLv2+
// Refer to the license.txt file included.

#ifndef OpenEmuAudioStream_hpp
#define OpenEmuAudioStream_hpp

#include "AudioCommon/SoundStream.h"

/* the sample rate is hardcoded in the initializer of the SoundStream
 * base class */
#define OE_SAMPLERATE 48000

/* max bytes OE will request per pull: 4 frames at 48kHz stereo s16
 * = 48000 / 60 * 4 bytes/frame * 4 = 12800 bytes (~85ms headroom).
 * Larger than one video frame so the ring never starves. */
#define OE_SIZESOUNDBUFFER (48000 / 60 * 4 * 4)

class OpenEmuAudioStream final : public SoundStream
{
public:
    bool Init() override { return true; }
    bool SetRunning(bool running) override;
    static bool isValid() { return true; }
    int readAudio(void *buffer, int len);
    ~OpenEmuAudioStream() {};
private:
    bool running;
};

#endif /* OpenEmuAudioStream_hpp */
