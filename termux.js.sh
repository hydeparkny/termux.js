# download a Node script from Github and replace the Linux line 1
# shebang with the Termux location of the Node binary
GITREPO="https://raw.githubusercontent.com/hydeparkny/"
GITBRANCH="master/"
PATHNAME="${1}"
TARGETDIR="${2}"
REPODIR="$(dirname ${PATHNAME})/"
FILEPATH=$(echo ${PATHNAME}|sed "s!^${REPODIR}!!")
FILENAME="$(basename ${PATHNAME})"

# default to mobile dir "~/bin" if dir not specified
if [ -z "${TARGETDIR}" ];then
cd ~/bin
else
cd ${TARGETDIR}
fi

# use curl instead of wget ; termux wget cannot do https
# neither wget nor curl set file permissions (other than default umask)
# for file GET via http/https , so set execute attribute below for some files
curl -O ${GITREPO}${REPODIR}${GITBRANCH}${FILEPATH}

# do special stuff for certain files
# using {} for command list w/o subshell ; unlike [] , need ; at end of list
# do this shebang edit only for Node.js scripts
grep -q '^#!/usr/bin/env node' ${FILENAME} && { \
 EDITCMDS="1\ns@#!/usr/bin/env node@#!/data/data/com.termux/files/usr/bin/node@\nw\nq\n" ;\
 echo -e ${EDITCMDS} | ed ${FILENAME} ;\
 chmod +x ${FILENAME} ;\
}

# set execute for .sh files
# maybe remove Linux shebang that is wrong for Termux ?
echo "${FILENAME}" | grep -q '.sh$' && { \
 chmod +x ${FILENAME} ;\
}

#
# #!/data/data/com.termux/files/usr/bin/node
# https://raw.githubusercontent.com/hydeparkny/tech/master/voip.ms.api/voipms.js
