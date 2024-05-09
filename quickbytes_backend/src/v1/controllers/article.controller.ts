import httpStatus from "http-status";
import ApiSuccess from "../../utils/ApiSuccess";
import catchAsync from "../../utils/catchAsync";
import { articleService } from "../services";

const createArticle = catchAsync(async (req, res) => {
  const response = await articleService.createArticle(req.body);

  res.status(httpStatus.CREATED).send(
    ApiSuccess({
      message: `Created Article!`,
      data: response,
    })
  );
});

const queryArticles = catchAsync(async (req, res) => {
  const { category_ids, cursor_id, limit }: any = req.query;

  console.log(req.query);

  const response = await articleService.queryArticles({
    categoryIds: category_ids,
    cursorId: cursor_id,
    limit: limit,
  });

  res.status(httpStatus.OK).send(
    ApiSuccess({
      message: `Query Articles.`,
      data: response,
    })
  );
});

const queryArticle = catchAsync(async (req, res) => {
  const { articleId }: any = req.params;

  const response = await articleService.queryArticle(articleId);

  res.status(httpStatus.OK).send(
    ApiSuccess({
      message: `Query Articles.`,
      data: response,
    })
  );
});

const testing = catchAsync(async (req, res) => {
  const response = await articleService.testing();

  res.status(httpStatus.OK).send(
    ApiSuccess({
      message: `Article Testing.`,
      data: response,
    })
  );
});

export default {
  createArticle,
  queryArticles,
  testing,
  queryArticle,
};
