alias n=nvim

# Password generator
pwgen() {
  local len=${1:-20}
  LC_ALL=C tr -dc 'A-Za-z0-9@#%^&*()_+=-{}[]:;<>,.?/' < /dev/urandom | head -c "$len" | xargs echo
}
