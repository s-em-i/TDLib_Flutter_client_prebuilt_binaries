import os
import sys
import asyncio
from telethon import TelegramClient, utils
from telethon.sessions import StringSession
from telethon.tl.types import PeerChannel
from telethon.tl import types

API_ID = int(os.getenv("API_ID"))
API_HASH = os.getenv("API_HASH")
SESSION = os.environ.get("SESSION")
CHAT_ID = int(os.getenv("CHAT_ID"))
MESSAGE_THREAD_ID = int(os.getenv("MESSAGE_THREAD_ID"))
COMMIT_MESSAGE = os.environ.get("COMMIT_MESSAGE")

def create_client():
    return TelegramClient(StringSession(SESSION), API_ID, API_HASH)

async def main():
    if not all([API_ID, API_HASH, SESSION, CHAT_ID]):
        print("[-] Missing required env vars!")
        sys.exit(1)
    
    print("[+] Starting Telethon upload")
    print("[+] Files:", sys.argv[1:])

    client = create_client()
    
    async with client:
        try:
            real_id, peer_type = utils.resolve_id(CHAT_ID)        
            entity = await client.get_entity(PeerChannel(real_id))
            print("[+] Entity Found") 
        except Exception as e:
            print(f"[-] Failed to resolve chat entity: {e}")
            sys.exit(1)

        paths = sys.argv[1:]
        
        print(f"[+] Caption: {COMMIT_MESSAGE}")
        
        valid_files = []
        for one in paths:
            if not os.path.exists(one):
                print(f"[-] File not exist: {one}")
                continue
            valid_files.append(one)
            print(f"[+] Valid file: {one}")
        
        if not valid_files:
            print("[-] No valid files to upload!")
            return       
        
        if len(valid_files) == 1:
            print(f"[+] Uploading {len(valid_files)} file(")
            await client.send_file(
                entity,
                valid_files[0],
                caption=COMMIT_MESSAGE,
                reply_to=MESSAGE_THREAD_ID
            )
        else:
            print(f"[+] Uploading {len(valid_files)} files as album...")
            await client.send_file(
                entity,
                valid_files,
                caption=COMMIT_MESSAGE,
                reply_to=MESSAGE_THREAD_ID
            )
        
        print("[+] Album uploaded successfully!")
        print("[+] Done!")

if __name__ == "__main__":
    asyncio.run(main())
