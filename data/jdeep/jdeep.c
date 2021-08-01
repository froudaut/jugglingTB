// jdeep.c
//
// Copyright 1999-2005 by Jack Boyce (jboyce@users.sourceforge.net)

/************************************************************************/
/*   jdeep.c version 5.1           by Jack Boyce        2/17/99         */
/*                                 jboyce@users.sourceforge.net         */
/*                                                                      */
/*   This is a modification of the original j.c, optimized for speed.   */
/*   It is used to find prime (no subpatterns) asynch siteswaps.        */
/*   Basically it works by finding cycles in the state transition       */
/*   matrix.  Try the cases:                                            */
/*       jdeep 4 7                                                      */
/*       jdeep 5 8                                                      */
/*                                                                      */
/*   This software is released into the public domain.                  */
/************************************************************************/

/*
-------------------------------------------------------------------------
Version history:
   6/98    Version 1.0
   7/29/98 Version 2.0 adds the ability to search for block patterns (an
	       idea brazenly scammed from Johannes Waldmann), as well as provides
           more command line options to configure program behavior.
   8/2/98  Automatically finds patterns in dual graph, if that's faster.
   1/2/99  Version 3.0 implements a new algorithm (see below).  My machine
           now finds (3,9) in 10 seconds (rather than 24 hours with V2.0)!
   2/14/99 Version 5.0 can find superprime (and nearly superprime)
           patterns.  It also implements an improved algorithm for the
           standard mode, one which is aware of the shift cycles.
   2/17/99 Version 5.1 adds -inverse option to print inverses of patterns
           found in -super mode.
-------------------------------------------------------------------------
Documentation:

jdeep version 5.1           by Jack Boyce
   (02/17/99)               jboyce@users.sourceforge.net

The purpose of this program is to search for long prime asynch siteswap
patterns.  For an explanation of these terms, consult the page:
    http://www.juggling.org/help/siteswap/

Command-line format is:
    <# objects> <max. throw> [<min. length>] [options]

where:
    <# objects>   = number of objects in the patterns found
    <max. throw>  = largest throw value to use
    <min. length> = shortest patterns to find (optional, speeds search)

The various command-line options are:
    -block <skips>  find patterns in block form, allowing the specified
                       number of skips
    -super <shifts> find (nearly) superprime patterns, allowing the specified
                       number of shift throws
    -inverse        print inverse also, in -super mode
    -g              find ground-state patterns only
    -ng             find excited-state patterns only
    -full           print all patterns; otherwise only patterns as long
                       currently-longest one found are printed
    -noprint        suppress printing of patterns
    -exact          prints patterns of exact length specified (no longer)
    -x <throw1 throw2 ...>
                    exclude listed throws (speeds search)
    -trim           force graph trimming algorithm on
    -notrim         force graph trimming algorithm off
    -file           run in file output mode
    -time <secs>    run for specified time before stopping

File Output Mode:

The program can be run in "file output mode", where output is sent
to disk and the calculation can be interrupted and restarted.  (This
mode was added to facilitate very large, time-consuming searches.)

When you execute the program with file output mode on, a file called
"jdeep5.core" is created in the same directory as the application.
When the program stops (either as a result of setting a time limit
with the -time option, or pressing a key under MacOS, or finishing
execution) it outputs the current state of the calculation to
"jdeep5.core".  Executing the program again (no command lines input
needed this time) will load "jdeep.core" and resume the calculation,
again stopping when time runs out.  On successive runs, program output
is sent to the files "jdeep5.out.001", "jdeep5.out.002", etc.

VERY IMPORTANT: You must manually delete the "jdeep5.core" file when
a file output run is finished!  When the program sees this file at
startup it thinks it's in the middle of a calculation and ignores
the command line options.  (Thus making the program appear to behave
oddly.)

New Algorithm:

The new faster algorithm in version 3.0 was inspired by an algorithm
for finding Hamiltonian circuits in a directed graph due to Nicos
Christofides (see "Graph Theory: An Algorithmic Approach" by N.
Christofides, 1975 (Academic Press), ISBN 0-12-174350-0, Ch. 10).
My adaptation is quite simple and is roughly described as follows:

There is a new variable max_possible which starts at ns (the number of
states) and records the longest possible pattern that could come out of
the current partial path.

When a link is added to the path (from a to b),
	1)  delete all other links going out of a, to {c,d,...}, and
		"inupdate" {c,d,...}
	2)  delete all other links going into b, from {e,f,...}, and
		"outupdate" {e,f,...}

"inupdating" a vertex i consists of:

	If i has indegree 0:
		a)  decrement max_possible
		b)  if (max_possible < l) then backtrack
		c)  delete all links going out of i, to {j,k,...}
		d)  inupdate {j,k,...}

"outupdating" a vertex i consists of:

	If i has outdegree 0:
		a)  decrement max_possible
		b)  if (max_possible < l) then backtrack
		c)  delete all links from {j,k,...} going into i
		d)  outupdate {j,k,...}

This new procedure is not activated when searching for patterns in
block form (the additional overhead makes it slower than ordinary
searching), or when doing a -full search.  In the latter case there
is certainly a cutoff in the min_length parameter above which the
new algorithm would be more efficient, but I haven't determined
this cutoff.
-------------------------------------------------------------------------
*/



/* the following only applies in file output mode: */
/* number of leaves to search between checking for key events or timeout */
#define STEPSPERCHECK 50000L

/* #define STATELIST */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>


void die()
{
   printf("Insufficient memory\n");
   exit(0);
}


/*  num_states  --  This routine finds the number of allowed states for  */
/*                  a given number of balls and maximum throwing height. */

int num_states(int n, int h)
{
	int result = 1, num = h, denom = 1;
	
	if (h < (2*n))
		n = h - n;
		
	while (denom <= n) {
		result = (result * num) / denom;	/* always gives integer result */
		num--;
		denom++;
	}
	
	return result;
}


/*  gen_states  --  This recursively generates the possible states,    */
/*                  putting them into the state[] array.               */

int gen_states(unsigned long *state, int num, int pos, int left, int h, int ns)
{
	if (left > (pos+1))
		return num;
		
	if (pos == 0) {
		if (left)
			state[num] |= 1L;
		else
			state[num] &= ~1L;
			
		if (num < (ns-1))
			state[num + 1] = state[num];
		return (num + 1);
	}

	state[num] &= ~(1L << pos);
	num = gen_states(state, num, pos-1, left, h, ns);
	if (left > 0) {
		state[num] |= 1L << pos;
		num = gen_states(state, num, pos-1, left-1, h, ns);
	}
	
	return num;
}


/*  gen_matrix  --  Once the states are found, this routine generates    */
/*                  a matrix containing the outward connections from     */
/*                  each vertex, and the throw value for each connection */
/*                  (outmatrix[][] == 0 indicates no connection)            */


void gen_matrix(int **outmatrix, int **outthrowval, int maxoutdegree, int *outdegree,
				int **inmatrix, int maxindegree, int *indegree,
				unsigned long *state, int h, int ns, int *xarray)
{
	int i, j, k, outthrownum, inthrownum;
	unsigned long temp, temp2;
	int found;
	
	for (i = 1; i <= ns; i++) {
		outthrownum = inthrownum = 0;
		for (j = h; j >= 0; j--) {
			if (xarray[j] == 0) {
					/* first take care of outgoing throw */
				if (j == 0) {
					if (!(state[i] & 1L)) {
						temp = state[i] >> 1;
						found = 0;
						for (k = 1; k <= ns; k++) {
							if (state[k] == temp) {
								outmatrix[i][outthrownum] = k;
								outthrowval[i][outthrownum++] = j;
								outdegree[i]++;
								found = 1;
								break;
							}
						}
						if (found == 0)
							printf("Error:  Couldn't find state! (1)\n");
					}
				} else {
					if (state[i] & 1L) {
						temp = (unsigned long)1L << (j-1);
						temp2 = (state[i] >> 1);
						if (!(temp2 & temp)) {
							temp |= temp2;
							found = 0;
							for (k = 1; k <= ns; k++) {
								if (state[k] == temp) {
									if (i != k) {
										outmatrix[i][outthrownum] = k;
										outthrowval[i][outthrownum++] = j;
										outdegree[i]++;
									}
									found = 1;
									break;
								}
							}
							if (found == 0)
								printf("Error:  Couldn't find state! (2)\n");
						}
					}
				}
				
					/* then take care of ingoing throw */
				if (j == 0) {
					if (!(state[i] & (1L << (h-1)))) {
						temp = state[i] << 1;
						found = 0;
						for (k = 1; k <= ns; k++) {
							if (state[k] == temp) {
								inmatrix[i][inthrownum++] = k;
								indegree[i]++;
								found = 1;
								break;
							}
						}
						if (found == 0)
							printf("Error:  Couldn't find state! (3)\n");
					}
				} else if (j == h) {
					if (state[i] & (1L << (h-1))) {
						temp = state[i] ^ (1L << (h-1));
						temp = (temp << 1) | 1L;
						found = 0;
						for (k = 1; k <= ns; k++) {
							if (state[k] == temp) {
								if (i != k) {
									inmatrix[i][inthrownum++] = k;
									indegree[i]++;
								}
								found = 1;
								break;
							}
						}
						if (found == 0)
							printf("Error:  Couldn't find state! (4)\n");
					}
				} else {
					if ((state[i] & (1L << (j-1))) &&
									(!(state[i] & (1L << (h-1))))) {
						temp = state[i] ^ (1L << (j-1));
						temp = (temp << 1) | 1L;
						found = 0;
						for (k = 1; k <= ns; k++) {
							if (state[k] == temp) {
								if (i != k) {
									inmatrix[i][inthrownum++] = k;
									indegree[i]++;
								}
								found = 1;
								break;
							}
						}
						if (found == 0)
							printf("Error:  Couldn't find state! (4)\n");
					}
				}
			}
		}
	}
}


/* The following structure stores the entire state of the calculation.  */
/* This is done so that the calculation can be conveniently stopped and */
/* started.                                                             */

#define NORMAL_MODE		1
#define BLOCK_MODE		2
#define SUPER_MODE		3


struct core {
		/* static variables (unchanged through run) */
	int mode;
	
	int skiplimit;		/* for block mode */
	int shiftlimit;		/* for super mode */
	
	int printflag;
	int invertflag;
	int trimflag;
	int exactflag;
	int longestflag;
	int dualflag;		/* find patterns in dual graph? */
	int groundmode;
	
	int n;
	int h;
	int l;
	int ns;
	int maxoutdegree;
	int maxindegree;
	int maxlength;
	int timelimiton;
	double timelimit;
	
		/* dynamic variables */
	int start;
	unsigned long npatterns;
	unsigned long ntotal;
	double timespent;	/* in seconds */
	int nextfilenum;
	int finished;
	int *xarray;		/* argument to prepcorearrays() */
	int *pattern;		/* created by prepcorearrays() */
	
		/* below this line doesn't need to be saved on stop */
	int pos;
	int from;
	int firstblocklength;
	int skipcount;
	int shiftcount;
	int blocklength;
	int max_possible;
	FILE *fpout;
	time_t timestart;
	int reload;
	int reloadcount;
	int fileoutputflag;
	long stepstaken;
		
		/* below this is created by prepcorearrays() */
	unsigned long *state;
	int **outmatrix;
	int **outthrowval;
	int *outdegree;
	int **inmatrix;
	int *indegree;
	int *used;
	int *thrownum;
	int **partners;		/* for finding superprime patterns */
	int *cyclenum;		/* cycle number for state */
	int numcycles;		/* total number of shift cycles */
	int *cycleperiod;	/* indexed by shift cycle number */
	int *deadstates;	/* indexed by shift cycle number */
/*	int *statelist;*/
} core;


void prepcorearrays(struct core *jcore, int *xa) {
	int i, j;
	int k, cycleindex, periodfound, cycleperiod, newshiftcycle, *tempperiod;
	unsigned long temp, highmask, lowmask;

				/* initialize arrays */
	jcore->xarray = xa;		/* array of throw values to exclude */
		
/*	if ((jcore->pattern = (int *)malloc((jcore->ns+1) * sizeof(int))) == 0)
		die();*/
	if ((jcore->used = (int *)malloc((jcore->ns+1) * sizeof(int))) == 0)
		die();
	if ((jcore->thrownum = (int *)malloc((jcore->ns+2) * sizeof(int))) == 0)
		die();
		
	if ((jcore->state = (unsigned long *)malloc((jcore->ns+2) * sizeof(unsigned long))) == 0)
		die();
	if ((jcore->outmatrix = (int **)malloc((jcore->ns+1) * sizeof(int *))) == 0)
		die();
	for (i = 0; i <= jcore->ns; i++)
		if ((jcore->outmatrix[i] = (int *)malloc(jcore->maxoutdegree * sizeof(int))) == 0)
			die();
	if ((jcore->outthrowval = (int **)malloc((jcore->ns+1) * sizeof(int *))) == 0)
		die();
	for (i = 0; i <= jcore->ns; i++)
		if ((jcore->outthrowval[i] = (int *)malloc(jcore->maxoutdegree * sizeof(int))) == 0)
			die();
	if ((jcore->outdegree = (int *)malloc((jcore->ns+1) * sizeof(int))) == 0)
		die();
	if ((jcore->inmatrix = (int **)malloc((jcore->ns+1) * sizeof(int *))) == 0)
		die();
	for (i = 0; i <= jcore->ns; i++)
		if ((jcore->inmatrix[i] = (int *)malloc(jcore->maxindegree * sizeof(int))) == 0)
			die();
	if ((jcore->indegree = (int *)malloc((jcore->ns+1) * sizeof(int))) == 0)
		die();
/*	if ((jcore->statelist = (int *)malloc((jcore->ns+1) * sizeof(int))) == 0)
		die();*/
		
	if ((jcore->partners = (int **)malloc((jcore->ns+1) * sizeof(int *))) == 0)
		die();
	for (i = 0; i <= jcore->ns; i++)
		if ((jcore->partners[i] = (int *)malloc((jcore->h - 1) * sizeof(int))) == 0)
			die();
	if ((jcore->cyclenum = (int *)malloc((jcore->ns+1) * sizeof(int *))) == 0)
		die();
	
	for (i = 0; i <= jcore->ns; i++)
		jcore->state[i] = 0L;

	(void)gen_states(jcore->state+1, 0, jcore->h - 1, jcore->n, jcore->h, jcore->ns);
							/* generate list of states */

	for (i = 0; i <= jcore->ns; i++) {
		for (j = 0; j < jcore->maxoutdegree; j++)
			jcore->outmatrix[i][j] = jcore->outthrowval[i][j] = 0;
		for (j = 0; j < jcore->maxindegree; j++)
			jcore->inmatrix[i][j] = 0;
		jcore->indegree[i] = jcore->outdegree[i] = 0;
	}
	
	gen_matrix(jcore->outmatrix, jcore->outthrowval, jcore->maxoutdegree, jcore->outdegree,
					jcore->inmatrix, jcore->maxindegree, jcore->indegree,
					jcore->state, jcore->h, jcore->ns, jcore->xarray);
	
		/* now calculate shift cycles */
	highmask = 1L << (jcore->h - 1);
	lowmask = highmask - 1;
	cycleindex = 0;
	if ((tempperiod = (int *)malloc((jcore->ns+1) * sizeof(int))) == 0)
		die();
		
	for (i = 1; i <= jcore->ns; i++) {
		for (j = 0; j < (jcore->h-1); j++)
			jcore->partners[i][j] = 0;
		
		temp = jcore->state[i];
		periodfound = 0;
		newshiftcycle = 1;
		cycleperiod = jcore->h;		/* default period */
		
		for (j = 0; j < (jcore->h - 1); j++) {
			if (temp & highmask)
				temp = ((temp & lowmask) * 2) + 1;
			else
				temp *= 2;
				
			for (k = 1; k <= jcore->ns; k++)
				if (jcore->state[k] == temp)
					break;
			if (k > jcore->ns) {
				fprintf(stderr, "Error 1 in prepcorearrays()\n");
				exit(0);
			}
			jcore->partners[i][j] = k;
			if ((k == i) && (!periodfound)) {
				cycleperiod = j+1;
				periodfound = 1;
			} else if (k < i)
				newshiftcycle = 0;
		}
		
		if (newshiftcycle) {
			jcore->cyclenum[i] = cycleindex;
			for (j = 0; j < (jcore->h - 1); j++)
				jcore->cyclenum[jcore->partners[i][j]] = cycleindex;
			tempperiod[cycleindex++] = cycleperiod;
		}
	}
	jcore->numcycles = cycleindex;
	if ((jcore->cycleperiod = (int *)malloc(cycleindex * sizeof(int *))) == 0)
		die();
	if ((jcore->deadstates = (int *)malloc(cycleindex * sizeof(int *))) == 0)
		die();
	for (i = 0; i < cycleindex; i++) {
		jcore->cycleperiod[i] = tempperiod[i];
		jcore->deadstates[i] = 0;
	}
	
	jcore->pattern = tempperiod;
	
	for (i = 0; i <= jcore->ns; i++) {
		jcore->pattern[i] = -1;
		jcore->thrownum[i] = jcore->used[i] = /* jcore->statelist[i] =*/ 0;
	}
	jcore->thrownum[jcore->ns+1] = 0;
		
/*	printf("%d shift cycles -- periods = {%d", jcore->numcycles, jcore->cycleperiod[0]);
	for (i = 1; i < cycleindex; i++)
		printf(", %d", jcore->cycleperiod[i]);
	printf("}\n");*/
}


int writecore(struct core *jcore, FILE *fpcore) {
	int i, j;
	
	fprintf(fpcore, "static variables:\n");
	fprintf(fpcore, "mode = %d\n", jcore->mode);
	fprintf(fpcore, "skiplimit = %d\n", jcore->skiplimit);
	fprintf(fpcore, "shiftlimit = %d\n", jcore->shiftlimit);
	fprintf(fpcore, "printflag = %d\n", jcore->printflag);
	fprintf(fpcore, "invertflag = %d\n", jcore->invertflag);
	fprintf(fpcore, "trimflag = %d\n", jcore->trimflag);
	fprintf(fpcore, "exactflag = %d\n", jcore->exactflag);
	fprintf(fpcore, "longestflag = %d\n", jcore->longestflag);
	fprintf(fpcore, "dualflag = %d\n", jcore->dualflag);
	fprintf(fpcore, "groundmode = %d\n", jcore->groundmode);
	
	fprintf(fpcore, "\nn = %d\n", jcore->n);
	fprintf(fpcore, "h = %d\n", jcore->h);
	fprintf(fpcore, "l = %d\n", jcore->l);
	fprintf(fpcore, "ns = %d\n", jcore->ns);
	fprintf(fpcore, "maxoutdegree = %d\n", jcore->maxoutdegree);
	fprintf(fpcore, "maxindegree = %d\n", jcore->maxindegree);
	fprintf(fpcore, "maxlength = %d\n", jcore->maxlength);
	fprintf(fpcore, "timelimiton = %d\n", jcore->timelimiton);
	fprintf(fpcore, "timelimit = %lf\n", jcore->timelimit);
	
	fprintf(fpcore, "\ncurrent state variables:\n");
	fprintf(fpcore, "start = %d\n", jcore->start);
	fprintf(fpcore, "npatterns = %ld\n", jcore->npatterns);
	fprintf(fpcore, "ntotal = %ld\n", jcore->ntotal);
	fprintf(fpcore, "timespent = %lf\n", jcore->timespent);
	fprintf(fpcore, "nextfilenum = %d\n", jcore->nextfilenum);
	fprintf(fpcore, "finished = %d\n", jcore->finished);
	
	fprintf(fpcore, "\nxarray:\n");
	for (i = 0; i <= jcore->h; i++)
		fprintf(fpcore, "%ld\n", jcore->xarray[i]);
	fprintf(fpcore, "\npattern:\n");
	for (i = 0; i <= jcore->ns; i++)
		fprintf(fpcore, "%d\n", jcore->pattern[i]);
	
	return 1;
}


int readcore(struct core *jcore, FILE *fpcore) {
	int i, j, *xa;
	
	fscanf(fpcore, "static variables:\n");
	fscanf(fpcore, "mode = %d\n", &(jcore->mode));
	fscanf(fpcore, "skiplimit = %d\n", &(jcore->skiplimit));
	fscanf(fpcore, "shiftlimit = %d\n", &(jcore->shiftlimit));
	fscanf(fpcore, "printflag = %d\n", &(jcore->printflag));
	fscanf(fpcore, "invertflag = %d\n", &(jcore->invertflag));
	fscanf(fpcore, "trimflag = %d\n", &(jcore->trimflag));
	fscanf(fpcore, "exactflag = %d\n", &(jcore->exactflag));
	fscanf(fpcore, "longestflag = %d\n", &(jcore->longestflag));
	fscanf(fpcore, "dualflag = %d\n", &(jcore->dualflag));
	fscanf(fpcore, "groundmode = %d\n", &(jcore->groundmode));

	fscanf(fpcore, "\nn = %d\n", &(jcore->n));
	fscanf(fpcore, "h = %d\n", &(jcore->h));
	fscanf(fpcore, "l = %d\n", &(jcore->l));
	fscanf(fpcore, "ns = %d\n", &(jcore->ns));
	fscanf(fpcore, "maxoutdegree = %d\n", &(jcore->maxoutdegree));
	fscanf(fpcore, "maxindegree = %d\n", &(jcore->maxindegree));
	fscanf(fpcore, "maxlength = %d\n", &(jcore->maxlength));
	fscanf(fpcore, "timelimiton = %d\n", &(jcore->timelimiton));
	fscanf(fpcore, "timelimit = %lf\n", &(jcore->timelimit));

	fscanf(fpcore, "\ncurrent state variables:\n");
	fscanf(fpcore, "start = %d\n", &(jcore->start));
	fscanf(fpcore, "npatterns = %ld\n", &(jcore->npatterns));
	fscanf(fpcore, "ntotal = %ld\n", &(jcore->ntotal));
	fscanf(fpcore, "timespent = %lf\n", &(jcore->timespent));
	fscanf(fpcore, "nextfilenum = %d\n", &(jcore->nextfilenum));
	fscanf(fpcore, "finished = %d\n", &(jcore->finished));
	
	if (jcore->finished) {
		fclose(fpcore);
		exit(0);
	}
	
	jcore->pos = 0;
	jcore->from = 1;
	jcore->firstblocklength = -1;
	jcore->skipcount = 0;
	jcore->shiftcount = 0;
	jcore->blocklength = 0;
	jcore->reload = 0;
	jcore->reloadcount = 0;
	jcore->fileoutputflag = 1;
	jcore->stepstaken = STEPSPERCHECK;
	
	if ((xa = (int *)malloc((jcore->h + 1) * sizeof(int))) == 0)
		die();                 /* excluded self-throws */
	for (i = 0; i <= jcore->h; i++)
		xa[i] = 0;

	fscanf(fpcore, "\nxarray:\n");
	for (i = 0; i <= jcore->h; i++)
		fscanf(fpcore, "%ld\n", xa + i);
		
	prepcorearrays(jcore, xa);
	
	fscanf(fpcore, "\npattern:\n");
	for (i = 0; i <= jcore->ns; i++)
		fscanf(fpcore, "%d\n", &(jcore->pattern[i]));
	
	return 1;
}


void print_inverse(struct core *jcore)
{
	int i, avoid, start, shifts, current, index, temp;
	int numshiftthrows, endingshiftthrows, errorflag;
	unsigned long tempstate;
	
	if (jcore->dualflag == 0) {		
			/* first decide on a starting state */

			/* state to avoid on first shift cycle: */
		avoid = reverse_state(jcore, jcore->start);
			/* how many adjacent states to avoid also? */
		shifts = 0;
		index = 0;
		while ((index <= jcore->pos) &&
					((jcore->pattern[index] == 0) || (jcore->pattern[index] == jcore->h)) ) {
			index++;
			shifts++;
		}
		
		if (index == jcore->pos) {
			fprintf(jcore->fpout, "no inverse");
			return;
		}
		
		start = jcore->ns;
		for (i = jcore->cycleperiod[jcore->cyclenum[avoid]] - 2; i >= shifts; i--) {
			if (jcore->partners[avoid][i] < start) {
				start = jcore->partners[avoid][i];
				temp = i;
			}
		}
		if (start == jcore->ns) {
			fprintf(jcore->fpout, "no inverse");
			return;
		}
		
		numshiftthrows = temp - shifts;		/* number of shift throws printed at beginning */
		endingshiftthrows = jcore->cycleperiod[jcore->cyclenum[start]] - shifts - 2 - numshiftthrows;
		current = start;
		
		do {
				/* first print shift throws */
			while (numshiftthrows--) {
				if (jcore->state[current] & 1)
					fprintf(jcore->fpout, "+");
				else
					fprintf(jcore->fpout, "-");
					
				current = jcore->partners[current][jcore->cycleperiod[jcore->cyclenum[current]]-2];
			}
			
				/* now print the block throw */
			temp = jcore->h - jcore->pattern[index++];
			
			if (temp < 10)
				fprintf(jcore->fpout, "%d", temp);
			else
				fprintf(jcore->fpout, "%c", temp - 10 + 'A');
		
			tempstate = (jcore->state[current] / 2) | (1L << (temp-1));
			errorflag = 1;
			for (i = 1; i <= jcore->ns; i++) {
				if (jcore->state[i] == tempstate) {
					current = i;
					errorflag = 0;
					break;
				}
			}
			if (errorflag == 1) {
				fprintf(stderr, "\nError 1: print_inverse()\n");
				return;
				exit(0);
			}
			
				/* now find how many shift throws in the next block */
			shifts = 0;
			while ((index <= jcore->pos) &&
						((jcore->pattern[index] == 0) || (jcore->pattern[index] == jcore->h)) ) {
				index++;
				shifts++;
			}
			numshiftthrows = jcore->cycleperiod[jcore->cyclenum[current]] - shifts - 2;
		} while (index <= jcore->pos);
		
			/* finish printing shift throws in first shift cycle */
		while (endingshiftthrows--) {
			if (jcore->state[current] & 1)
				fprintf(jcore->fpout, "+");
			else
				fprintf(jcore->fpout, "-");
				
			current = jcore->partners[current][jcore->cycleperiod[jcore->cyclenum[current]]-2];
		}
	} else {
			/* inverse was found in dual space, so we have to transform as we read it */
			
			/* first decide on a starting state */

			/* dual state to avoid on first shift cycle: */
		avoid = reverse_state(jcore, jcore->start);
		
			/* how many adjacent states to avoid also? */
		shifts = 0;
		index = jcore->pos;
		while ((index >= 0) &&
					((jcore->pattern[index] == 0) || (jcore->pattern[index] == jcore->h)) ) {
			index--;
			shifts++;
		}
		
		if (index < 0) {
			fprintf(jcore->fpout, "no inverse");
			return;
		}

		start = jcore->ns;
		for (i = 0; i <= jcore->cycleperiod[jcore->cyclenum[avoid]]-shifts-2; i++) {
			if (jcore->partners[avoid][i] < start) {
				start = jcore->partners[avoid][i];
				temp = i;
			}
		}
		if (start == jcore->ns) {
			fprintf(jcore->fpout, "no inverse");
			return;
		}
		
			/* number of shift throws printed at beginning */
		numshiftthrows = jcore->cycleperiod[jcore->cyclenum[start]]-shifts-2 - temp;
		endingshiftthrows = temp;
		current = start;
		
		do {
				/* first print shift throws */
			while (numshiftthrows--) {
				if (jcore->state[current] & (1L << (jcore->h-1)))
					fprintf(jcore->fpout, "-");
				else
					fprintf(jcore->fpout, "+");
					
				current = jcore->partners[current][0];
			}
			
				/* now print the block throw */
			temp = jcore->pattern[index--];
			
			if (temp < 10)
				fprintf(jcore->fpout, "%d", temp);
			else
				fprintf(jcore->fpout, "%c", temp - 10 + 'A');
		
			tempstate = (jcore->state[current]*2 + 1) ^ (1L << (jcore->h-temp));
			errorflag = 1;
			for (i = 1; i <= jcore->ns; i++) {
				if (jcore->state[i] == tempstate) {
					current = i;
					errorflag = 0;
					break;
				}
			}
			if (errorflag == 1) {
				fprintf(stderr, "\nError 1: print_inverse()\n");
				return;
				exit(0);
			}
			
				/* now find how many shift throws in the next block */
			shifts = 0;
			while ((index >= 0) &&
						((jcore->pattern[index] == 0) || (jcore->pattern[index] == jcore->h)) ) {
				index--;
				shifts++;
			}
			numshiftthrows = jcore->cycleperiod[jcore->cyclenum[current]] - shifts - 2;
		} while (index >= 0);
		
			/* finish printing shift throws in first shift cycle */
		while (endingshiftthrows--) {
			if (jcore->state[current] & (1L << (jcore->h-1)))
				fprintf(jcore->fpout, "-");
			else
				fprintf(jcore->fpout, "+");
				
			current = jcore->partners[current][0];
		}
	}
}


void print_pattern(struct core *jcore)
{
	int i, j, k, plusminus;
#ifdef STATELIST
	unsigned long temp2;
#endif

	if (jcore->groundmode != 1) {
		if (jcore->start == 1)
			fprintf(jcore->fpout, "  ");
		else
			fprintf(jcore->fpout, "* ");
	}
	
	for (i = 0; i <= jcore->pos; i++) {
		if (jcore->dualflag == 1)
			j = jcore->h - jcore->pattern[jcore->pos-i];
		else
			j = jcore->pattern[i];
		
		plusminus = 0;
		if ((jcore->mode == NORMAL_MODE) && jcore->longestflag)
			plusminus = 1;
		if (jcore->mode == BLOCK_MODE)
			plusminus = 1;

		if (plusminus) {
			if (j == 0)
				fprintf(jcore->fpout, "-");
			else if (j == jcore->h)
				fprintf(jcore->fpout, "+");
			else if (j < 10)
				fprintf(jcore->fpout, "%d", j);
			else
				fprintf(jcore->fpout, "%c", j - 10 + 'A');
		} else {
			if (j < 10)
				fprintf(jcore->fpout, "%d", j);
			else
				fprintf(jcore->fpout, "%c", j - 10 + 'A');
		}
	}
	
	if (jcore->invertflag == 1) {
		fprintf(jcore->fpout, " : ");
		print_inverse(jcore);
	}
						
	if (jcore->start != 1)
		fprintf(jcore->fpout, " *");

	fprintf(jcore->fpout, "\n");

#ifdef STATELIST	
	fprintf(jcore->fpout, "  missing states:\n");
	
	for (i = jcore->start + 1; i <= jcore->ns; i++) {
		if (jcore->used[i] == 0) {
			temp2 = jcore->state[i];
			for (j = 0; j < jcore->h; j++) {
				if (temp2 & 1)
					fprintf(jcore->fpout, "x");
				else
					fprintf(jcore->fpout, "-");
				temp2 /= 2;
			}
			fprintf(jcore->fpout, "\n");
		}
	}
#endif
}


int reverse_state(struct core *jcore, int statenum)
{
	int i;
	unsigned long temp = 0;
	unsigned long mask1 = 1L, mask2 = 1L << (jcore->h - 1);
	unsigned long state = jcore->state[statenum];
	
	while (mask2) {
		if (state & mask2)
			temp |= mask1;
		mask1 *= 2;
		mask2 /= 2;
	}
	
	for (i = 1; i <= jcore->ns; i++)
		if (jcore->state[i] == temp)
			break;
	
	if (i > jcore->ns) {
		fprintf(stderr, "Error: reverse_state()\n");
		exit(0);
	}
	
	return i;
}


void print_trailer(struct core *jcore)
{
	int temp;
	
	temp = jcore->n;
	if (jcore->dualflag == 1)
		temp = jcore->h - temp;

	fprintf(jcore->fpout, "balls: %d, max throw: %d\n", temp, jcore->h);
	
	switch (jcore->mode) {
		case NORMAL_MODE:
			break;
		case BLOCK_MODE:
			fprintf(jcore->fpout, "block mode, %d skips allowed\n", jcore->skiplimit);
			break;
		case SUPER_MODE:
			fprintf(jcore->fpout, "super mode, %d shifts allowed", jcore->shiftlimit);
			if (jcore->invertflag)
				fprintf(jcore->fpout, ", inverse output\n");
			else
				fprintf(jcore->fpout, "\n");
			break;
	}
		
	if (jcore->longestflag) {
		temp = jcore->l;
			
		fprintf(jcore->fpout, "pattern length: %d throws (%d maximum, %d states)\n", temp,
					jcore->maxlength, jcore->ns);
	}
	
	fprintf(jcore->fpout, "%d patterns found (%d seen)\n", jcore->npatterns, jcore->ntotal);

	if (jcore->groundmode == 1)
		fprintf(jcore->fpout, "ground state search\n");
	if (jcore->groundmode == 2)
		fprintf(jcore->fpout, "excited state search\n");
		
	fprintf(jcore->fpout, "running time = %.0f sec\n", jcore->timespent);
}


/* Insert your own code here to halt execution.  In file mode, the core  */
/* will be written out and the calculation will resume when the program  */
/* is restarted.                                                         */

int stopcondition(struct core *jcore) {
	double timeworking = difftime(time(NULL), jcore->timestart);

	if (jcore->timelimiton == 1)
		if (timeworking >= jcore->timelimit)
			return 1;

	return 0;
}

void lookforstop(struct core *jcore) {
	if (stopcondition(jcore)) {
		double timespent = difftime(time(NULL), jcore->timestart);
		
		jcore->timespent += timespent;
		
		if (jcore->fileoutputflag) {
			FILE *fpcore;
			
			fprintf(jcore->fpout, "current search length = %d (max. %d), ", jcore->l,
					jcore->maxlength);
			fprintf(jcore->fpout, "time spent this run = %.0f sec\n", timespent);
			fclose(jcore->fpout);
			
			if ((fpcore = fopen("jdeep5.core", "w")) == 0) {
				fprintf(stderr, "Error: Can't open file: jdeep5.core\n");
				exit(0);
			}
			
			jcore->nextfilenum++;
			
			writecore(jcore, fpcore);
			fclose(fpcore);
			exit(0);
		} else {
			fprintf(jcore->fpout, "run stopped\n");
			print_trailer(jcore);
			fclose(jcore->fpout);
			exit(0);
		}
	}
}


void gen_loops_normal(struct core *jcore);
void gen_loops_block(struct core *jcore);
void gen_loops_super(struct core *jcore);


void inupdate(struct core *jcore, int statenum, int slot)
{
	int i, to;
	
	while ((statenum <= jcore->ns) &&
				((jcore->indegree[statenum] != 0) || (jcore->outdegree[statenum] == 0))) {
		statenum++;
		slot = 0;
	}
	
	if (statenum == (jcore->ns+1)) {
			/* finished with inupdate.  add another link to path */
		switch (jcore->mode) {
			case NORMAL_MODE:
				gen_loops_normal(jcore);
				break;
			case BLOCK_MODE:
				gen_loops_block(jcore);
				break;
			case SUPER_MODE:
				gen_loops_super(jcore);
				break;
		}
	} else {
			/* indegree of current state is zero, outdegree is not.  delete a link */
		for (; slot < jcore->maxoutdegree; slot++) {
			to = jcore->outmatrix[statenum][slot];
			if (to == 0)
				return;
			if (to > 0) {
				for (i = 0; i < jcore->maxindegree; i++)
					if (jcore->inmatrix[to][i] == statenum)
						break;
						
				if (jcore->outdegree[statenum] == 1) {
					if (jcore->max_possible <= jcore->l)
						return;
					jcore->max_possible--;
				}
				jcore->outmatrix[statenum][slot] = -1;
				jcore->outdegree[statenum]--;
				jcore->inmatrix[to][i] = -1;
				jcore->indegree[to]--;
				
				if ((jcore->indegree[to] == 0) && (to < statenum))
					inupdate(jcore, to, 0);				/* continue earlier */
				else
					inupdate(jcore, statenum, slot+1);	/* continue here */
					
				jcore->outmatrix[statenum][slot] = to;
				if (jcore->outdegree[statenum] == 0)
					jcore->max_possible++;
				jcore->outdegree[statenum]++;
				jcore->inmatrix[to][i] = statenum;
				jcore->indegree[to]++;
				return;
			}
		}
	}
}

void outupdate(struct core *jcore, int statenum, int slot)
{
	int i, from;
	
	while ((statenum <= jcore->ns) &&
				((jcore->outdegree[statenum] != 0) || (jcore->indegree[statenum] == 0))) {
		statenum++;
		slot = 0;
	}
	
	if (statenum == (jcore->ns+1)) {
			/* finished with current recursion */
		inupdate(jcore, jcore->start, 0);
	} else {
			/* outdegree of current state is zero, indegree is not.  delete a link */
		for (; slot < jcore->maxindegree; slot++) {
			from = jcore->inmatrix[statenum][slot];
			if (from == 0)
				return;
			if (from > 0) {
				for (i = 0; i < jcore->maxoutdegree; i++)
					if (jcore->outmatrix[from][i] == statenum)
						break;
						
				if (jcore->indegree[statenum] == 1) {
					if (jcore->max_possible <= jcore->l)
						return;
					jcore->max_possible--;
				}
				jcore->inmatrix[statenum][slot] = -1;
				jcore->indegree[statenum]--;
				jcore->outmatrix[from][i] = -1;
				jcore->outdegree[from]--;
				
				if ((jcore->outdegree[from] == 0) && (from < statenum))
					outupdate(jcore, from, 0);			/* continue earlier */
				else
					outupdate(jcore, statenum, slot+1);	/* continue here */
					
				jcore->inmatrix[statenum][slot] = from;
				if (jcore->indegree[statenum] == 0)
					jcore->max_possible++;
				jcore->indegree[statenum]++;
				jcore->outmatrix[from][i] = statenum;
				jcore->outdegree[from]++;
				return;
			}
		}
	}
}

void trim_ingoing(struct core *jcore, int from_trim, int to_trim, int slot)
{
	int i, from;

	for (; slot < jcore->maxindegree; slot++) {
		from = jcore->inmatrix[to_trim][slot];
		if (from == 0)
			break;
		if ((from > 0) && (from != from_trim)) {
			jcore->inmatrix[to_trim][slot] = -1;
			for (i = 0; i < jcore->maxoutdegree; i++) {
				if (jcore->outmatrix[from][i] == to_trim) {
					jcore->outmatrix[from][i] = -1;
					break;
				}
			}
			jcore->indegree[to_trim]--;
			jcore->outdegree[from]--;
			trim_ingoing(jcore, from_trim, to_trim, slot+1);
			jcore->inmatrix[to_trim][slot] = from;
			jcore->outmatrix[from][i] = to_trim;
			jcore->indegree[to_trim]++;
			jcore->outdegree[from]++;
			return;
		}
	}

	outupdate(jcore, jcore->start, 0);
}

void trim_outgoing(struct core *jcore, int from_trim, int to_trim, int slot)
{
	int i, to;

	for (; slot < jcore->maxoutdegree; slot++) {
		to = jcore->outmatrix[from_trim][slot];
		if (to == 0)
			break;
		if ((to > 0) && (to != to_trim)) {
			jcore->outmatrix[from_trim][slot] = -1;
			for (i = 0; i < jcore->maxindegree; i++) {
				if (jcore->inmatrix[to][i] == from_trim) {
					jcore->inmatrix[to][i] = -1;
					break;
				}
			}
			jcore->outdegree[from_trim]--;
			jcore->indegree[to]--;
			trim_outgoing(jcore, from_trim, to_trim, slot+1);
			jcore->outmatrix[from_trim][slot] = to;
			jcore->inmatrix[to][i] = from_trim;
			jcore->outdegree[from_trim]++;
			jcore->indegree[to]++;
			return;
		}
	}
	
	trim_ingoing(jcore, from_trim, to_trim, 0);
}


void gen_loops_normal(struct core *jcore)
{
	int i, to, valid, temp;
	int start = jcore->start;
	int l = jcore->l;
	int *pattern = jcore->pattern;
	int *used = jcore->used;
	int pos = jcore->pos;
	int from = jcore->from;
	int **outmatrix = jcore->outmatrix;
	int **outthrowval = jcore->outthrowval;
	int maxoutdegree = jcore->maxoutdegree;
	int *outmatrixptr = outmatrix[from];
	int *outthrowptr = outthrowval[from];
	
	if (jcore->exactflag && (pos >= l))
		return;
		
	i = 0;
	
	if (jcore->reload == 1) {
		if (pattern[jcore->reloadcount] == -1)
			jcore->reload = 0;
		else {
			for (; i < maxoutdegree; i++)
				if (outthrowptr[i] == pattern[jcore->reloadcount])
					break;
			if (i == maxoutdegree) {
				fprintf(stderr, "Error: Couldn't restart");
				exit(0);
			}
			jcore->reloadcount++;
		}
	}
		
	for (; i < maxoutdegree; i++) {
		to = outmatrixptr[i];

		if ((to >= start) && (used[to] == 0)) {
			
				/* are we finished? */
			if (to == start) {
				jcore->ntotal++;
				if ((pos >= (l-1)) || (l == 0)) {
					if (jcore->printflag) {
						pattern[pos] = outthrowptr[i];
						print_pattern(jcore);
					}
					if (jcore->longestflag)
						if (pos >= l) {
							l = jcore->l = pos+1;
							jcore->npatterns = 0;
						}
					jcore->npatterns++;
				}
			} else {
				int j, cyclenum, tempstatenum;
				unsigned long tempstate;
				unsigned long highmask = 1L << (jcore->h - 1);
				unsigned long allmask = (1L << jcore->h) - 1;

					/* continue recursively, if current position is valid */
				valid = 1;
				temp = outthrowptr[i];
				
				if (jcore->trimflag) {
						/* block throw? */
					if ((temp > 0) && (temp < jcore->h)) {
							/* kill states downstream in 'from' cycle that end in 'x' */
						j = jcore->h - 2;
						tempstate = jcore->state[from];
						cyclenum = jcore->cyclenum[from];
						
						do {
							tempstatenum = jcore->partners[from][j];
						
							if (jcore->used[tempstatenum]++ == 0) {
								if (jcore->deadstates[cyclenum]++ >= 1) {
									if (--jcore->max_possible < jcore->l)
										valid = 0;
								}
							}
							
							j--;
							tempstate /= 2;
						} while (tempstate & 1L);
						
							/* kill states upstream in 'to' cycle that start with '-' */
						j = 0;
						tempstate = jcore->state[to];
						cyclenum = jcore->cyclenum[to];
						
						do {
							tempstatenum = jcore->partners[to][j];
						
							if (jcore->used[tempstatenum]++ == 0) {
								if (jcore->deadstates[cyclenum]++ >= 1) {
									if (--jcore->max_possible < jcore->l)
										valid = 0;
								}
							}
							
							j++;
							tempstate = (tempstate << 1) & allmask;
						} while ((tempstate & highmask) == 0);

					}
				}
				
				if (valid) {
					used[to] = 1;
						
					pattern[pos] = temp;
					jcore->pos++;
					jcore->from = to;
					
					gen_loops_normal(jcore);
						
					used[to] = 0;
						
					jcore->pos--;
					jcore->from = from;
					l = jcore->l;
				}
				
					/* undo changes so we can backtrack */
				if (jcore->trimflag) {
						/* block throw? */
					if ((temp > 0) && (temp < jcore->h)) {
							/* kill states downstream in 'from' cycle that end in 'x' */
						j = jcore->h - 2;
						tempstate = jcore->state[from];
						cyclenum = jcore->cyclenum[from];
						
						do {
							tempstatenum = jcore->partners[from][j];
						
							if (--jcore->used[tempstatenum] == 0)
								if (--jcore->deadstates[cyclenum] >= 1)
									jcore->max_possible++;
							
							j--;
							tempstate /= 2;
						} while (tempstate & 1L);
						
							/* kill states upstream in 'to' cycle that start with '-' */
						j = 0;
						tempstate = jcore->state[to];
						cyclenum = jcore->cyclenum[to];
						
						do {
							tempstatenum = jcore->partners[to][j];
						
							if (--jcore->used[tempstatenum] == 0)
								if (--jcore->deadstates[cyclenum] >= 1)
									jcore->max_possible++;
							
							j++;
							tempstate = (tempstate << 1) & allmask;
						} while ((tempstate & highmask) == 0);

					}
				}
				
					/* check for stop? */
				if (--jcore->stepstaken == 0) {
					if (valid)
						jcore->pattern[pos+1] = -1;
					else
						jcore->pattern[pos] = -1;
					
					lookforstop(jcore);
					jcore->stepstaken = STEPSPERCHECK;
				}

			}
		}
	}
}


void gen_loops_block(struct core *jcore)
{
	int i, to, valid, temp;
	int oldblocklength, oldskipcount, oldfirstblocklength;
	int start = jcore->start;
	int l = jcore->l;
	int *pattern = jcore->pattern;
	int *used = jcore->used;
	int pos = jcore->pos;
	int from = jcore->from;
	int **outmatrix = jcore->outmatrix;
	int **outthrowval = jcore->outthrowval;
	int maxoutdegree = jcore->maxoutdegree;
	int *outmatrixptr = outmatrix[from];
	int *outthrowptr = outthrowval[from];

	if (jcore->exactflag && (jcore->pos >= jcore->l))
		return;
		
	i = 0;
	
	if (jcore->reload == 1) {
		if (pattern[jcore->reloadcount] == -1)
			jcore->reload = 0;
		else {
			for (; i < maxoutdegree; i++)
				if (outthrowptr[i] == pattern[jcore->reloadcount])
					break;
			if (i == maxoutdegree) {
				fprintf(stderr, "Error: Couldn't restart");
				exit(0);
			}
			jcore->reloadcount++;
		}
	}
		
	for (; i < maxoutdegree; i++) {
		to = outmatrixptr[i];
		if ((to >= start) && (used[to] != 1)) {
				/* are we finished? */
			if (to == start) {
				jcore->ntotal++;
				if ((pos >= (l-1)) || (l == 0)) {
					temp = outthrowptr[i];
					valid = 1;
					
					oldblocklength = jcore->blocklength;
					oldskipcount = jcore->skipcount;
					oldfirstblocklength = jcore->firstblocklength;
					
					if ((temp > 0) && (temp < jcore->h)) {		/* block throw? */
						if (jcore->firstblocklength >= 0) {		/* gotten one before? */
							if (jcore->blocklength != (jcore->h-2)) {		/* got a skip */
								if (jcore->skipcount == jcore->skiplimit)	/* over limit? */
									valid = 0;
								else
									jcore->skipcount++;
							}
						} else		/* first block throw encountered */
							jcore->firstblocklength = pos;
							
						jcore->blocklength = 0;
					} else
						jcore->blocklength++;
						
					if ((jcore->skipcount == jcore->skiplimit) &&
							((jcore->blocklength + jcore->firstblocklength) != (jcore->h-2)))
						valid = 0;

					if (valid) {
						if (jcore->printflag) {
							pattern[pos] = temp;
							print_pattern(jcore);
						}
						if (jcore->longestflag)
							if (pos >= l) {
								l = jcore->l = pos+1;
								jcore->npatterns = 0;
							}
						jcore->npatterns++;
					}

					jcore->blocklength = oldblocklength;
					jcore->skipcount = oldskipcount;
					jcore->firstblocklength = oldfirstblocklength;
				}
			} else {
				temp = outthrowptr[i];
				valid = 1;
				
				oldblocklength = jcore->blocklength;
				oldskipcount = jcore->skipcount;
				oldfirstblocklength = jcore->firstblocklength;
				
				if ((temp > 0) && (temp < jcore->h)) {		/* block throw? */
					if (jcore->firstblocklength >= 0) {		/* gotten one before? */
						if (jcore->blocklength != (jcore->h-2)) {		/* got a skip */
							if (jcore->skipcount == jcore->skiplimit)	/* over limit? */
								valid = 0;
							else
								jcore->skipcount++;
						}
					} else		/* first block throw encountered */
						jcore->firstblocklength = pos;
						
					jcore->blocklength = 0;
				} else
					jcore->blocklength++;
				
					/* continue recursively, if current position is valid */
				if (valid) {
					used[to] = 1;
					
					pattern[pos] = temp;
					jcore->pos++;
					jcore->from = to;
					
					if (jcore->trimflag)
						trim_outgoing(jcore, from, to, 0);
					else
						gen_loops_block(jcore);
					
					used[to] = 0;
					
					jcore->pos--;
					jcore->from = from;
					l = jcore->l;
				}
				
					/* undo changes so we can backtrack */
				jcore->blocklength = oldblocklength;
				jcore->skipcount = oldskipcount;
				jcore->firstblocklength = oldfirstblocklength;
								
					/* check for stop? */
				if (--jcore->stepstaken == 0) {
					if (valid)
						jcore->pattern[pos+1] = -1;
					else
						jcore->pattern[pos] = -1;
					
					lookforstop(jcore);
					jcore->stepstaken = STEPSPERCHECK;
				}

			}
		}
	}
}


void gen_loops_super(struct core *jcore)
{
	int i, to, valid, temp;
	int oldshiftcount;
	int start = jcore->start;
	int l = jcore->l;
	int *pattern = jcore->pattern;
	int *used = jcore->used;
	int pos = jcore->pos;
	int from = jcore->from;
	int **outmatrix = jcore->outmatrix;
	int **outthrowval = jcore->outthrowval;
	int maxoutdegree = jcore->maxoutdegree;
	int *outmatrixptr = outmatrix[from];
	int *outthrowptr = outthrowval[from];

	if (jcore->exactflag && (jcore->pos >= jcore->l))
		return;
		
	i = 0;
	
	if (jcore->reload == 1) {
		if (pattern[jcore->reloadcount] == -1)
			jcore->reload = 0;
		else {
			for (; i < maxoutdegree; i++)
				if (outthrowptr[i] == pattern[jcore->reloadcount])
					break;
			if (i == maxoutdegree) {
				fprintf(stderr, "Error: Couldn't restart");
				exit(0);
			}
			jcore->reloadcount++;
		}
	}
		
	for (; i < maxoutdegree; i++) {
		to = outmatrixptr[i];
		if ((to >= start) && (used[to] != 1)) {
				/* are we finished? */
			if (to == start) {
				jcore->ntotal++;
				if ((pos >= (l-1)) || (l == 0)) {
					temp = outthrowptr[i];
					valid = 1;
					
					if (jcore->shiftlimit > 0) {
						if ((temp == 0) || (temp == jcore->h)) {	/* non-block throw */
							if (jcore->shiftcount == jcore->shiftlimit)
								valid = 0;
						}
					}
					
					if (valid) {
						if (jcore->printflag) {
							pattern[pos] = temp;
						/*	if (jcore->invertflag)
								jcore->statelist[pos] = (jcore->dualflag ? from : to);*/
							print_pattern(jcore);
						}
						if (jcore->longestflag)
							if (pos >= l) {
								l = jcore->l = pos+1;
								jcore->npatterns = 0;
							}
						jcore->npatterns++;
					}
				}
			} else {
				temp = outthrowptr[i];
				valid = 1;
				
				oldshiftcount = jcore->shiftcount;
				
				if ((temp == 0) || (temp == jcore->h)) {	/* non-block throw */
					if (jcore->shiftcount == jcore->shiftlimit)
						valid = 0;
					else
						jcore->shiftcount++;
				} else {
					if (used[to] < 0)
						valid = 0;		/* block throw into occupied shift cycle */
				}
				
					/* continue recursively, if current position is valid */
				if (valid) {
					int j, oldusedvalue;
						
					oldusedvalue = used[to];
					used[to] = 1;
					
					for (j = 0; j < (jcore->h - 1); j++) {
						if (used[jcore->partners[to][j]] < 1)
							used[jcore->partners[to][j]]--;
					}
						
				/*	jcore->statelist[jcore->pos] = (jcore->dualflag ? from : to);*/
					
					pattern[pos] = temp;
					jcore->pos++;
					jcore->from = to;
					
					if (jcore->trimflag)
						trim_outgoing(jcore, from, to, 0);
					else
						gen_loops_super(jcore);
					
					for (j = 0; j < (jcore->h - 1); j++) {
						if (used[jcore->partners[to][j]] < 0)
							used[jcore->partners[to][j]]++;
					}
					
					used[to] = oldusedvalue;
					
					jcore->pos--;
					jcore->from = from;
					l = jcore->l;
				}
				
					/* undo changes so we can backtrack */
				jcore->shiftcount = oldshiftcount;
				
					/* check for stop? */
				if (--jcore->stepstaken == 0) {
					if (valid)
						jcore->pattern[pos+1] = -1;
					else
						jcore->pattern[pos] = -1;
					
					lookforstop(jcore);
					jcore->stepstaken = STEPSPERCHECK;
				}
				
			}
		}
	}
}


void delete_vertices(struct core *jcore, int statenum)
{
	int i, j, temp;
	
	if (statenum >= jcore->start)
		outupdate(jcore, jcore->start, 0);
	else {
		if (jcore->indegree[statenum] != 0) {
			for (i = 0; i < jcore->maxindegree; i++)
				if (jcore->inmatrix[statenum][i] > 0)
					break;
			temp = jcore->inmatrix[statenum][i];
			for (j = 0; j < jcore->maxoutdegree; j++)
				if (jcore->outmatrix[temp][j] == statenum)
					break;
			if (j == jcore->maxoutdegree) {
				fprintf(stderr, "Error 1: delete_vertices()\n");
				exit(0);
			}
			jcore->inmatrix[statenum][i] = -1;
			jcore->outmatrix[temp][j] = -1;
			jcore->indegree[statenum]--;
			jcore->outdegree[temp]--;
			delete_vertices(jcore, statenum);
			jcore->inmatrix[statenum][i] = temp;
			jcore->outmatrix[temp][j] = statenum;
			jcore->indegree[statenum]++;
			jcore->outdegree[temp]++;
			return;
		} else if (jcore->outdegree[statenum] != 0) {
			for (i = 0; i < jcore->maxoutdegree; i++)
				if (jcore->outmatrix[statenum][i] > 0)
					break;
			temp = jcore->outmatrix[statenum][i];
			for (j = 0; j < jcore->maxindegree; j++)
				if (jcore->inmatrix[temp][j] == statenum)
					break;
			if (j == jcore->maxindegree) {
				fprintf(stderr, "Error 2: delete_vertices()\n");
				exit(0);
			}
			jcore->outmatrix[statenum][i] = -1;
			jcore->inmatrix[temp][j] = -1;
			jcore->outdegree[statenum]--;
			jcore->indegree[temp]--;
			delete_vertices(jcore, statenum);
			jcore->outmatrix[statenum][i] = temp;
			jcore->inmatrix[temp][j] = statenum;
			jcore->outdegree[statenum]++;
			jcore->indegree[temp]++;
			return;
		} else {
			delete_vertices(jcore, statenum+1);
			return;
		}
	}
}


void gen_patterns(struct core *jcore)
{
	int i;
	
	jcore->timestart = time(NULL);

	if (jcore->reload != 1)
		jcore->start = (jcore->groundmode==2) ? 2 : 1;
		
	for (; jcore->start <= ((jcore->groundmode==1) ? 1 : jcore->ns); jcore->start++) {
		jcore->from = jcore->start;
		jcore->pos = 0;
		jcore->firstblocklength = -1;	/* -1 signals unknown */
		jcore->skipcount = 0;

		for (i = 0; i <= jcore->ns; i++)
			jcore->used[i] = 0;
		
		switch (jcore->mode) {
			case NORMAL_MODE:
				jcore->max_possible = jcore->maxlength;
				delete_vertices(jcore, 1);
				break;
			case BLOCK_MODE:
				if (jcore->longestflag) {
					jcore->max_possible = jcore->ns - jcore->start + 1;
					if (jcore->max_possible >= jcore->l)
						delete_vertices(jcore, 1);
				} else {
					jcore->max_possible = jcore->ns;
					delete_vertices(jcore, 1);
				}
				break;
			case SUPER_MODE:
				for (i = 0; i < (jcore->n - 1); i++)
					jcore->used[jcore->partners[jcore->start][i]] = 1;
				jcore->max_possible = jcore->ns;
				delete_vertices(jcore, 1);
				break;
		}
	}
	
	jcore->timespent += difftime(time(NULL), jcore->timestart);
}




int main(int argc, char **argv)
{
	int 			i, j, *xa, trimspecified = 0;
	struct core 	jcore;
	char 			filename[80];
	FILE 			*fpcore;
	
	if ((fpcore = fopen("jdeep5.core", "r")) != 0) {
		readcore(&jcore, fpcore);
		fclose(fpcore);
		if (jcore.finished)
			exit(0);
		jcore.reload = 1;
		jcore.reloadcount = 0;
	} else {
	
			/* initialize everything but arrays */
		jcore.mode = NORMAL_MODE	;
		jcore.printflag = 1;
		jcore.invertflag = 0;
		
		jcore.n = 0;
		jcore.h = 0;
		jcore.l = 0;
		jcore.ns = 0;
		jcore.maxoutdegree = 0;
		jcore.maxindegree = 0;
		jcore.maxlength = 0;
		jcore.groundmode = 0;
		jcore.trimflag = 1;
		jcore.exactflag = 0;
		jcore.timelimiton = 0;
		jcore.timelimit = 0.0;
		jcore.longestflag = 1;
		jcore.skiplimit = 0;
		jcore.shiftlimit = 0;
		jcore.dualflag = 0;
		
		jcore.start = 1;
		jcore.npatterns = 0L;
		jcore.ntotal = 0L;
		jcore.timespent = 0.0;
		jcore.nextfilenum = 1;
		jcore.finished = 0;
		
		jcore.pos = 0;
		jcore.from = 1;
		jcore.firstblocklength = -1;
		jcore.skipcount = 0;
		jcore.shiftcount = 0;
		jcore.blocklength = 0;
		jcore.max_possible = 0;
		jcore.reload = 0;
		jcore.reloadcount = 0;
		jcore.fileoutputflag = 0;
		jcore.stepstaken = STEPSPERCHECK;
		jcore.numcycles = 0;
		
		if (argc < 3) {
			printf(
"jdeep version 5.1           by Jack Boyce\n");
			printf(
"   (02/17/99)                  jboyce@users.sourceforge.net\n\n");
			printf(
"The purpose of this program is to search for long prime asynch siteswap\n");
			printf(
"patterns.  For an explanation of these terms, consult the page:\n");
			printf(
"    http://www.juggling.org/help/siteswap/\n\n");
			printf(
"Command-line format is:\n");
			printf(
"	jdeep <# objects> <max. throw> [<min. length>] [options]\n\n");
			printf(
"where:\n    <# objects>   = number of objects in the patterns found\n");
			printf(
"    <max. throw>  = largest throw value to use\n");
			printf(
"    <min. length> = shortest patterns to find (optional, speeds search)\n\n");
			printf(
"The various command-line options are:\n");
			printf(
"    -block <skips>  find patterns in block form, allowing the specified\n");
			printf(
"                       number of skips\n");
			printf(
"    -super <shifts> find (nearly) superprime patterns, allowing the specified\n");
			printf(
"                       number of shift throws\n");
			printf(
"    -inverse        print inverse also, in -super mode\n");
			printf(
"    -g              find ground-state patterns only\n");
			printf(
"    -ng             find excited-state patterns only\n");
			printf(
"    -full           print all patterns; otherwise only patterns as long\n");
			printf(
"                       currently-longest one found are printed\n");
			printf(
"    -noprint        suppress printing of patterns\n");
			printf(
"    -exact          prints patterns of exact length specified (no longer)\n");
			printf(
"    -x <throw1 throw2 ...>\n");
			printf(
"                    exclude listed throws (speeds search)\n");
			printf(
"    -trim           force graph trimming algorithm on\n");
			printf(
"    -notrim         force graph trimming algorithm off\n");
			printf(
"    -file           run in file output mode\n");
			printf(
"    -time <secs>    run for specified time before stopping\n");
			exit(0);
		}

		jcore.n = atoi(argv[1]);              /* get the number of objects */
		if (jcore.n < 1) {
			printf("Must have at least 1 object\n");
			exit(0);
		}
		jcore.h = atoi(argv[2]);                    /* get the max. throw height */
		if (jcore.h < jcore.n) {
			printf("Max. throw height must equal or exceed number of objects\n");
			exit(0);
		}
		
		if ((xa = (int *)malloc((jcore.h + 1) * sizeof(int))) == 0)
			die();                 /* excluded self-throws */
		for (i = 0; i <= jcore.h; i++)
			xa[i] = 0;
			
		for (i = 3; i < argc; i++) {
			if (!strcmp(argv[i], "-noprint"))
				jcore.printflag = 0;
			else if (!strcmp(argv[i], "-inverse"))
				jcore.invertflag = 1;
			else if (!strcmp(argv[i], "-g"))
				jcore.groundmode = 1;
			else if (!strcmp(argv[i], "-ng"))
				jcore.groundmode = 2;
			else if (!strcmp(argv[i], "-trim")) {
				trimspecified = 1;
				jcore.trimflag = 1;
			} else if (!strcmp(argv[i], "-notrim")) {
				trimspecified = 1;
				jcore.trimflag = 0;
			} else if (!strcmp(argv[i], "-full"))
				jcore.longestflag = 0;
			else if (!strcmp(argv[i], "-exact")) {
				jcore.exactflag = 1;
				jcore.longestflag = 0;
				if (jcore.l < 2) {
					printf("Must specify a length > 1 when using -exact flag\n");
					exit(0);
				}
			} else if (!strcmp(argv[i], "-super")) {
				if ((i+1) < argc) {
					if (jcore.mode != NORMAL_MODE) {
						printf("Can only select one mode at a time\n");
						exit(0);
					}
					jcore.mode = SUPER_MODE;
					jcore.shiftlimit = (double)atoi(argv[++i]);
					if (jcore.shiftlimit == 0)
						xa[0] = xa[jcore.h] = 1;
				} else {
					printf("Must provide shift limit in -super mode\n");
					exit(0);
				}
			} else if (!strcmp(argv[i], "-file"))
				jcore.fileoutputflag = 1;
			else if (!strcmp(argv[i], "-time")) {
				if ((i+1) < argc) {
					jcore.timelimiton = 1;
					jcore.timelimit = (double)atoi(argv[++i]);
				}
			}
			else if (!strcmp(argv[i], "-block")) {
				if ((i+1) < argc) {
					if (jcore.mode != NORMAL_MODE) {
						printf("Can only select one mode at a time\n");
						exit(0);
					}
					jcore.mode = BLOCK_MODE;
					jcore.skiplimit = (double)atoi(argv[++i]);
				} else {
					printf("Must provide skip limit in -block mode\n");
					exit(0);
				}
			}
			else if (!strcmp(argv[i], "-x")) {
				i++;
				while ((i < argc) && (argv[i][0] != '-')) {
					j = atoi(argv[i]);
					if ((j >= 0) && (j <= jcore.h))
						xa[(jcore.dualflag == 1) ? (jcore.h - j) : j] = 1;
					i++;
				}
				i--;
			} else
				jcore.l = atoi(argv[i]);
		}

			/* consistency checks */
		if (jcore.invertflag && (jcore.mode != SUPER_MODE)) {
			printf("-inverse flag can only be used in -super mode\n");
			exit(0);
		}
			
			/* defaults for going into dual space */
		if (jcore.h > (2 * jcore.n)) {
			jcore.dualflag = 1;
			jcore.n = jcore.h - jcore.n;
		}
		
			/* defaults for when to trim and when not to */
		if (!trimspecified) {
			if (jcore.mode == BLOCK_MODE)
				jcore.trimflag = 0;
			else if (jcore.mode == SUPER_MODE)
				jcore.trimflag = 0;
			else if (jcore.longestflag)
				jcore.trimflag = 1;
			else
				jcore.trimflag = 0;
		}
		
		jcore.ns = num_states(jcore.n, jcore.h);			/* number of states */
		jcore.maxoutdegree = jcore.h + 1;	/* max. number of throws from any state */
		for (i = 0; i <= jcore.h; i++)
			if (xa[i] == 1)
				jcore.maxoutdegree--;
		if (jcore.maxoutdegree > (jcore.h - jcore.n + 1))
			jcore.maxoutdegree = jcore.h - jcore.n + 1;
		jcore.maxindegree = jcore.n + 1;
		
		prepcorearrays(&jcore, xa);
		
		if (jcore.mode == SUPER_MODE)
			jcore.maxlength = jcore.numcycles + jcore.shiftlimit;
		else
			jcore.maxlength = jcore.ns - jcore.numcycles;

			/* check if pattern is impossible */
		if (jcore.l > jcore.maxlength) {
			printf("No patterns longer than %d possible\n", jcore.maxlength);
			exit(0);
		}
	}

	if (jcore.fileoutputflag) {
		sprintf(filename, "jdeep5.out.%.3d", jcore.nextfilenum);
		if ((jcore.fpout = fopen(filename, "w")) == 0) {
			fprintf(stderr, "Error: Can't open file: %s\n", filename);
			exit(0);
		}
	} else
		jcore.fpout = stdout;

	gen_patterns(&jcore);

	print_trailer(&jcore);
	
	if (jcore.fileoutputflag) {
		fclose(jcore.fpout);
		jcore.finished = 1;		/* mark finished in case we try to restart */
		if ((fpcore = fopen("jdeep5.core", "w")) != 0) {
			writecore(&jcore, fpcore);
			fclose(fpcore);
		}
	}

	return 0;
}
