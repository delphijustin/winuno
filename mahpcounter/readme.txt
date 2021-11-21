
Component Name: THPCounter
        Author: Mats Asplund
      Creation: 2000-09-17
       Version: 1.1
   Description: A high-precision counter/timer. Retrieves time differences
                downto microsec.
        Credit:
        E-mail: mats.asplund@telia.com
          Site: http://go.to/masdp
  Legal issues: Copyright (C) 2000 by Mats Asplund


         Usage: This software is provided 'as-is', without any express or
                implied warranty.  In no event will the author be held liable
                for any  damages arising from the use of this software.

                Permission is granted to anyone to use this software for any
                purpose, including commercial applications, and to alter it
                and redistribute it freely, subject to the following
                restrictions:

                1. The origin of this software must not be misrepresented,
                   you must not claim that you wrote the original software.
                   If you use this software in a product, an acknowledgment
                   in the product documentation would be appreciated but is
                   not required.

                2. Altered source versions must be plainly marked as such, and
                   must not be misrepresented as being the original software.

                3. This notice may not be removed or altered from any source
                   distribution.

                4. If you decide to use this software in any of your applications.
                   Send me an EMail address and tell me about it.

Quick Reference:
                THPCounter inherits from TComponent.

                Key-Methods:
                  Start:    Starts the counter. Place this call just before the
                            code you want to measure.

                  Read:     Reads the counter as a string. Place this call just
                            after the code you want to measure.

                  ReadInt:  Reads the counter as an Int64. Place this call just
                            after the code you want to measure.
