% Code from StackOverFlow by paulkernfeld.

function tree_to_code(tree, feature_names)
    tree_ = tree.tree_;
    feature_name = cell(length(tree_.feature), 1);
    for i = 1:length(tree_.feature)
        if i ~= tree_.TREE_UNDEFINED
            feature_name{i} = feature_names{i};
        else
            feature_name{i} = 'undefined!';
        end
    end

    fprintf('function tree(%s)\n', strjoin(feature_names, ', '));

    function recurse(node, depth)
        indent = repmat('  ', 1, depth);
        if tree_.feature(node) ~= tree_.TREE_UNDEFINED
            name = feature_name{node};
            threshold = tree_.threshold(node);
            fprintf('%sif %s <= %f\n', indent, name, threshold);
            recurse(tree_.children_left(node), depth + 1);
            fprintf('%selse\n', indent);
            recurse(tree_.children_right(node), depth + 1);
        else
            value = tree_.value(node, :);
            fprintf('%sreturn %s\n', indent, mat2str(value));
        end
    end

    recurse(1, 1);
    fprintf('end\n');
end

