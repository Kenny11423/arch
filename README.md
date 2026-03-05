# Archinstall
This is a personal automated Arch Installation script, changes may added.

## Notice!
This script aims for modularity so you'll have to do the networking, partitioning and mounting steps yourself (make sure to mount EFI as /boot).

## Usage:

If you want to change some part of the script.

Grab the script with:

```
curl -L https://raw.githubusercontent.com/Kenny11423/arch/main/arch-install.sh -o arch-install.sh
```
Review it with your editor of choice, example nano:

```
nano arch-install.sh
```

Then make it executable:

```
chmod +x arch-install.sh
```

Finally exec it:

```
./arch-install.sh
```

If you've reviewed the script and see the options suit to your use case, run it directly:

```
bash <(curl -fsSL https://raw.githubusercontent.com/Kenny11423/arch/main/arch-install.sh)
```

## Post installation:

You must clone the repository:

```
git clone https://github.com/Kenny11423/arch.git --depth 1
```

Make the post installation script executable (if it isn't already):

```
cd arch
sudo chmod +x post-install.sh
```

Run the script:

```
sudo ./post-install.sh
```
