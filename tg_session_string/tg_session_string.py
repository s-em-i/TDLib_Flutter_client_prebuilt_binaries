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
