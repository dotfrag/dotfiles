# ----------------------------------------------------------------------- DOCKER
check_com -c docker || check_com -c podman || return

# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/docker/docker.plugin.zsh
alias dbl='docker build'
alias din='docker container inspect'
alias dls='docker container ls'
alias dlsa='docker container ls -a'
alias dib='docker image build'
alias dii='docker image inspect'
alias dils='docker image ls'
alias diprune='docker image prune'
alias dipu='docker image push'
alias dipru='docker image prune -a'
alias dirm='docker image rm'
alias dit='docker image tag'
alias dlo='docker container logs'
alias dnc='docker network create'
alias dncn='docker network connect'
alias dndcn='docker network disconnect'
alias dni='docker network inspect'
alias dnls='docker network ls'
alias dnrm='docker network rm'
alias dpo='docker container port'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dpu='docker pull'
alias dr='docker container run'
alias drit='docker container run -it'
alias drm='docker container rm'
alias 'drm!'='docker container rm -f'
alias dst='docker container start'
alias drs='docker container restart'
alias dsta='docker stop $(docker ps -q)'
alias dstp='docker container stop'
alias dsts='docker stats'
alias dtop='docker top'
alias dvi='docker volume inspect'
alias dvls='docker volume ls'
alias dvprune='docker volume prune'
alias dvrm='docker volume rm'
alias dxc='docker container exec'
alias dxcit='docker container exec -it'

# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/docker-compose/docker-compose.plugin.zsh
# support Compose v2 as docker CLI plugin
(( ${+commands[docker-compose]} )) && dccmd='docker-compose' || dccmd='docker compose'

alias dco="${dccmd}"
alias dcb="${dccmd} build"
alias dce="${dccmd} exec"
alias dcps="${dccmd} ps"
alias dcrestart="${dccmd} restart"
alias dcrm="${dccmd} rm"
alias dcr="${dccmd} run"
alias dcstop="${dccmd} stop"
alias dcup="${dccmd} up"
alias dcupb="${dccmd} up --build"
alias dcupd="${dccmd} up -d"
alias dcupdb="${dccmd} up -d --build"
alias dcdn="${dccmd} down"
alias dcl="${dccmd} logs"
alias dclf="${dccmd} logs -f"
alias dclF="${dccmd} logs -f --tail 0"
alias dcls="${dccmd} ls"
alias dcpull="${dccmd} pull"
alias dcstart="${dccmd} start"
alias dck="${dccmd} kill"

unset dccmd

update-container() {
  [[ -f compose.yml ]] || return
  docker compose pull
  # docker compose down # not needed
  docker compose up -d
  docker image prune -f
}

update-containers() {
  for i in $(docker compose ls | awk '{print $1}' | tail +2); do
    d=$(docker container inspect "${i}" \
      --format '{{ index .Config.Labels "com.docker.compose.project.working_dir" }}')
    (
      cd "${d}" || exit
      update-container
    )
  done
  return
}
