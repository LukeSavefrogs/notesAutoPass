# Notes autoPass
This project aims to provide **password auto-typing** for **IBM Notes** (former Lotus Notes) on **Windows** only

## Introduction
I'm sick of having to open Keepass just to make it autotype my password into Notes login form (*yes... it doesn't allow pasting*).

That's why i created this script that opens Notes and types the password right away :)

## Usage
### Open Notes with password
To use this script you just need to call it with the `-p` parameter. Example: 
```
"C:\Users\Luca Salvarani\Desktop\Script\notesOpen.exe" -p=your_password
```
If the **password** or any other parameter value contains a <kbd>SPACE</kbd> character, make sure to enclose it first in single quotes, then in double quotes. Example:
```
"C:\Users\Luca Salvarani\Desktop\Script\notesOpen.exe" -p='"your password with spaces"'
```

There are several ways you can use this script:
- Create a desktop shortcut
- Add an alias on your CLI of choice

## Options
<table>
	<thead>
		<tr>
		<th>Parameter</th>
		<th>Type</th>
		<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				<code style='white-space: nowrap;'>-p</code> 
				<br>
				<code style='white-space: nowrap;'>--password</code>
			</td>
			<td>REQUIRED</td>
			<td>
				Specify password to be sent to the Login form
			</td>
		</tr>
		<tr>
			<td>
				<code style='white-space: nowrap;'>-d</code>
				<br>
				<code style='white-space: nowrap;'>--directory</code>
			</td>
			<td>OPTIONAL</td>
			<td>
				If you proceeded to a custom installation, you may have installed Notes in a custom path. 
				<br><br>
				This parameter lets you define the directory where is located the <code>notes.exe</code> executable file (<span style='font-style: italic'>default is <code>C:\Program Files (x86)\IBM\Notes\notes.exe</code></span>)
				<br><br>
				To specify a path containing a space character enclose it first in single quotes, then in double quotes, like this: <code>-d='"C:\My Custom Path\IBM\Notes\"'</code>
			</td>
		</tr>
		<tr>
			<td>
				<code style='white-space: nowrap;'>-u</code>
				<br>
				<code style='white-space: nowrap;'>--username</code>
			</td>
			<td>OPTIONAL</td>
			<td>
				<span>
					Changes the Username by selecting one in the dropdown. 
					<br>
					<br>
					<strong>NOTE</strong>: You MUST provide <strong>exactly</strong> the same value you would pick from the dropdown (in the example below: <code>Luca Salvarani/Italy/Contr/IBM</code>)
				</span>
				<br><br>
				<img width="400px" src="images/aec8498197bb1f691737180b931157dda7c348f12d982d52fd6773078510ea5f.png"/>  
			</td>
		</tr>
		<tr>
			<td>
				<code style='white-space: nowrap;'>-l</code>
				<br>
				<code style='white-space: nowrap;'>--location</code>
			</td>
			<td>OPTIONAL</td>
			<td>
				<span>
					Changes the desired Location by selecting one in the dropdown.
					<br>
					<br>
					<strong>NOTE</strong>: You MUST provide <strong>exactly</strong> the same value you would pick from the dropdown (in the example below: <code>IBM</code>)
				</span>
				<br><br>
				<img width="400px" src="images/5a09ce6e67d4b89179e216f9ad77c49c2783083bd594e0fd6c6f4a86bc11cc77.png">
			</td>
		</tr>
		<tr>
			<td>
				<code style='white-space: nowrap;'>-w</code>
				<br>
				<code style='white-space: nowrap;'>--wait-input</code>
			</td>
			<td>OPTIONAL</td>
			<td>
				Don't click on the login button after entering the password, but wait for user to click on it manually (it won't prevent the Username or Location to be changed, if present)
			</td>
		</tr>
		<tr>
			<td>
				<code style='white-space: nowrap;'>-t</code>
				<br>
				<code style='white-space: nowrap;'>--timeout</code>
			</td>
			<td>OPTIONAL</td>
			<td>
				Useful when changing the password. Simply autotypes the provided password into the focused element after the provided timeout in ms, so make sure to click <strong>into</strong> the input field before the timeout expires
			</td>
		</tr>
		<tr>
			<td>
				<code style='white-space: nowrap;'>-x</code>
				<br>
				<code style='white-space: nowrap;'>--debug</code>
			</td>
			<td>OPTIONAL</td>
			<td>
				Enables the Debug Mode. Shows a MsgBox with data useful for debugging
			</td>
		</tr>
		<tr>
			<td>
				<code style='white-space: nowrap;'>-h</code>
				<br>
				<code style='white-space: nowrap;'>--help</code>
			</td>
			<td>OPTIONAL</td>
			<td>
				Prints a small help on the available parameters
			</td>
		</tr>
	</tbody>
</table>