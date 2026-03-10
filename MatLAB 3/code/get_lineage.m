% code from StackOverFlow by Zelanzny7

function lineage = get_lineage(tree, feature_names)                         % track the decision path for any set of inputs
    left = tree.tree_.children_left;                                        
    right = tree.tree_.children_right;
    threshold = tree.tree_.threshold;
    features = cell(length(tree.tree_.feature), 1);
    for i = 1:length(tree.tree_.feature)
        features{i} = feature_names{tree.tree_.feature(i)};
    end

    idx = find(left == -1);

    function lineage = recurse(left, right, child, lineage)
        if nargin < 4
            lineage = {child};
        end
        if ismember(child, left)
            parent = find(left == child, 1);
            split = 'l';
        else
            parent = find(right == child, 1);
            split = 'r';
        end
        lineage{end+1} = [parent, split, threshold(parent), features{parent}];
        if parent == 0
            lineage = flip(lineage);
            return;
        else
            lineage = recurse(left, right, parent, lineage);
        end
    end

    for i = 1:numel(idx)
        child = idx(i);
        lineage = recurse(left, right, child);
        for j = 1:numel(lineage)
            node = lineage{j};
            disp(node);
        end
    end
end
