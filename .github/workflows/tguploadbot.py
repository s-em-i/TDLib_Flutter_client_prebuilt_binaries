import os
import sys
import asyncio
from telethon import TelegramClient
from telethon.sessions import StringSession

API_ID = int(os.getenv("API_ID"))
API_HASH = os.getenv("API_HASH")
SESSION = os.environ.get("SESSION")
CHAT_ID = os.environ.get("CHAT_ID")
MESSAGE_THREAD_ID = os.environ.get("MESSAGE_THREAD_ID")
COMMIT_MESSAGE = os.environ.get("COMMIT_MESSAGE")

def create_client():
    return TelegramClient(StringSession(SESSION), API_ID, API_HASH)

def get_caption():
    return COMMIT_MESSAGE + "\n"

async def main():
    if not all([API_ID, API_HASH, SESSION, CHAT_ID]):
        print("[-] Missing required env vars!")
        sys.exit(1)
    
    print("[+] Starting Telethon album upload")
    print("[+] Files:", sys.argv[1:])
    
    client = create_client()

    async with client:
        try:
            entity = await client.get_entity(CHAT_ID)
        except Exception as e:
            print(f"[-] Failed to resolve chat entity: {e}")
            sys.exit(1)

        paths = sys.argv[1:]
        caption = get_caption()
        
        print("[+] Caption:")
        print(caption)
        print("---")
        
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
        
        print(f"[+] Uploading {len(valid_files)} files as album...")
        
        if len(valid_files) == 1:
            await client.send_file(
                CHAT_ID,
                valid_files[0],
                caption=caption,
                reply_to=MESSAGE_THREAD_ID
            )
        else:
            await client.send_file(
                CHAT_ID,
                valid_files,
                caption=caption,
                reply_to=MESSAGE_THREAD_ID
            )
        
        print("[+] Album uploaded successfully!")
        print("[+] Done!")

if __name__ == "__main__":
    asyncio.run(main())
