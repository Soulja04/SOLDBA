/*
	Crash procedure for bulk and full recovery
	models

	Step 1: Backup the current log
	Step 2: Restore most recent full
	Step 3: Restore most recent differential
	Step 4: Restore all transaction log backups
		since the last differential in sequence
	
	Schedule:
		- Full: Saturdays 2300
		- Diff: Daily at 2300
		- Log: Hourly

	Consultant take a log backup at 10:30
		- By default, the log will be "cleared out"

	If, at 2:30 the drive holding the data file
	goes down, what is your restore sequence?

	Step 1: backup log
	Step 2: Restore Sat's full
	Step 3: Restore last night's differential
	Step 4: Restore all logs since the differential

	uh-oh... where did the consultant store
	the log backup? Was it on a removeable drive?

	Copy only backups are useful when you need to 
	take a backup, yet you don't want to change
	the restore sequence
		- Full
		- Log

	A full "copy only" backup is a full backup, 
	except it doesn't reset the differential
	"flag".
	
	Sat 2300: full backup
	Sun 2300: diff 
	Mon 2300: diff
	Tue 1030: copy only full backup
	Tue 2300: diff
	Wed 2300: diff
*/

BACKUP LOG Chapter07
	... WITH COPY_ONLY