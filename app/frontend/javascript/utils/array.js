const duplicateArray = (arr) => {
  const newArr = [];

  arr.forEach((i) => newArr.push(i));
  return newArr;
};

export {
  duplicateArray
};
