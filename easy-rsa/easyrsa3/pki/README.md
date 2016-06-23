private is ignored, and must be synced with s3. Scripting is TODO,
for now, do this:
user=newuser
aws s3 cp private/${user}.key s3://trueffect.com/devops/easyrsa3/pki/private/${user}.key
