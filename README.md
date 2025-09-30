# TDLib_Flutter_client_prebuilt_binaries
Prebuilt Binaries for serveral OS to build Flutter Client

## Telegram Upload Client
In order to use the Telegram Upload Client in your workflow, \
to upload your files into a specific Telegram Channel Topic, \
one must have valid Telegram Developer API Credentials from  \
**[Creating your Telegram Application](https://core.telegram.org/api/obtaining_api_id)** \
and a valid session String, which gets stored as Github Secret.\
Repo -> Settings -> Secrets and variables -> Repository secrets

Github Secrets you need:
* TELEGRAM_API_ID
* TELEGRAM_API_HASH
* TELEGRAM_SESSION
* TELEGRAM_CHANNEL_ID
* MESSAGE_THREAD_ID -> Telegram Channel Topic ID

**TELEGRAM_CHANNEL_ID** can be (i.e):
* -100xxxxxxxxxx (-1002968260999)
* xxxxxxxxxx (2968260999))
* `https://t.me/c/GroupName` (`https://t.me/c/TaPaccoSupport`)
* `https://t.me/GroupName` (`https://t.me/TaPaccoSupport`)
* @GroupName (@TaPaccoSupport)
* GroupName (TaPaccoSupport)

You can get the **MESSAGE_THREAD_ID** by <img alt="grafik" src="https://github.com/user-attachments/assets/fb007aea-01f2-48ed-96da-88ba4e6836fd" style="height: 1.5em;">\
from your topic: `https://t.me/TaPaccoSupport/2/247` \
-> **2** would be your **MESSAGE_THREAD_ID**.

### How to get your Telegram Session String
Save your **API_ID** and **API_HASH** into the `tg_session_string.py` script,\
run it, and it prints out a very long session string -> your **TELEGRAM_SESSION**

```
import telethon, sys
from telethon import TelegramClient
from telethon.sessions import StringSession

async def main(client: telethon.TelegramClient):

    if(not client.is_connected()):
        await client.connect()
    
    session_string = client.session.save()
    print(f"\nSESSION STRING (for GitHub Secrets):")
    print(session_string)

###### Script Entrypoint ######

api_id = ""
api_hash = ""

client = TelegramClient(StringSession(), api_id, api_hash)

with client:
   client.loop.run_until_complete(main(client))
```
	
## Telegram Group TDlib Prebuilt Binaries
[TDlib GitHub Prebuilt Binaries](https://t.me/TaPaccoSupport/2)

<a name="license"></a>
## License
`TDLib Flutter Client prebuilt Binaries` is licensed under the terms of the Boost Software License. See [LICENSE_1_0.txt](http://www.boost.org/LICENSE_1_0.txt) for more information.
