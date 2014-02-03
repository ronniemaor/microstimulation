function paperFitsSummary(parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    parms = add_parms(parms, ...
        'sessions', {'J29c', 'J29g', 'J29i', 'M18b', 'M18c', 'M18d', 'M18e', 'M25c', 'M25d', 'J26b', 'J26c'} ...
    );
    timeCourseSeveralSessions(parms);
    timeCourseSeveralSessions(add_parms(parms, 'summary', 'mean'));
    timeCourseSeveralSessions(add_parms(parms, 'summary', 'median', 'medianErrWidth', 15));
end
