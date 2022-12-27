function Scoop-Setup {
    Set-ExecutionPolicy Bypass -Scope Process -Force; 
    irm get.scoop.sh | iex
}