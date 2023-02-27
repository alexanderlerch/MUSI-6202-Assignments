function autograde(qid, data, studentId, instructorFlag, options)

    defaultOptions = struct();
    
    % CHANGE THIS TO LOCAL PATH
    defaultOptions.scoreOutputPath = "C:\\Users\\Karn\\OneDrive - Georgia Institute of Technology\\Teaching\\MUSI 6202\\Assignments\\MUSI-6202-Assignment-Solutions\\assignments\\assignment2\\instructor\\grades";
    
    defaultOptions.verbose = true;
    defaultOptions.penalizeTranspose = true;
    defaultOptions.transposePenalty = 0.25;
    defaultOptions.tol = 1e-8;
    
    mlx = matlab.desktop.editor.getActiveFilename;
    assignmentFolder = fileparts(fileparts(mlx));
    addpath(genpath(fullfile(assignmentFolder, "instructor", "grades")));
    addpath(genpath(fullfile(assignmentFolder, "instructor", "qgrader")));
    
    topFolder = fileparts(fileparts(assignmentFolder));
    addpath(genpath(fullfile(topFolder, "autograder")));

    if nargin < 4
        instructorFlag = 1;
    end

    if nargin < 5
        options = defaultOptions;
    else
        options = catstruct(defaultOptions, options);
    end

    if any(strcmp("gburdell3", studentId)) || any(strcmp("yjacket3", studentId))
        error("You forgot to set your student ID!");
    end

    if ~instructorFlag
        if qid == "summary"
            disp("End of Assignment 1.")
        else
            disp("******** Thank you, next ********");
        end
        return
    end

    if instructorFlag && ~(exist('q0Grader', 'file') == 2)
        error("The instructor flag is set, but the grader files are not present.");
    end
    

    if ~isfield(data, "comment")
        data.comment = "";
    end

    if isfield(data, "adjustment")
        if data.comment == ""
            warning("Score adjustment should preferably be accompanied by a grader's comment.")
        end
    else
        data.adjustment = 0;
    end

    switch (qid)
        case 'q0'
            q0Grader(data, studentId, options);
        case 'summary'
            if instructorFlag
                generateGradeReport(studentId, options);
            else
                disp("End of Assignment 1.")
            end
        otherwise
            error("Bad Question ID");
    end

end